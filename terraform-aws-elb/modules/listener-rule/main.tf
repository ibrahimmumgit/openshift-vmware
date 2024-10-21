resource "aws_lb_listener_rule" "lb_listener_rule" {
  count = var.module_enabled ? 1 : 0

  listener_arn = var.listener_arn

  priority = var.priority

  # Enable Cognito auth
  dynamic "action" {
    for_each = var.authenticate_cognito != null ? [var.authenticate_cognito] : []
    iterator = authenticate_cognito

    content {
      type = "authenticate-cognito"

      authenticate_cognito {
        user_pool_arn       = authenticate_cognito.value.user_pool_arn
        user_pool_domain    = authenticate_cognito.value.user_pool_domain
        user_pool_client_id = authenticate_cognito.value.user_pool_client_id

        authentication_request_extra_params = try(authenticate_cognito.value.authentication_request_extra_params, null)
        on_unauthenticated_request          = try(authenticate_cognito.value.on_unauthenticated_request, null)
        scope                               = try(authenticate_cognito.value.scope, null)
        session_cookie_name                 = try(authenticate_cognito.value.session_cookie_name, null)
        session_timeout                     = try(authenticate_cognito.value.session_timeout, null)
      }
    }
  }

  # Enable OIDC auth
  dynamic "action" {
    for_each = var.authenticate_oidc != null ? [var.authenticate_oidc] : []
    iterator = authenticate_oidc

    content {
      type = "authenticate-oidc"

      authenticate_oidc {
        authorization_endpoint = authenticate_oidc.value.authorization_endpoint
        client_id              = authenticate_oidc.value.client_id
        client_secret          = authenticate_oidc.value.client_secret
        issuer                 = authenticate_oidc.value.issuer

        authentication_request_extra_params = try(authenticate_oidc.value.authentication_request_extra_params, null)
        on_unauthenticated_request          = try(authenticate_oidc.value.on_unauthenticated_request, null)
        scope                               = try(authenticate_oidc.value.scope, null)
        session_cookie_name                 = try(authenticate_oidc.value.session_cookie_name, null)
        session_timeout                     = try(authenticate_oidc.value.session_timeout, null)

        token_endpoint     = authenticate_oidc.value.token_endpoint
        user_info_endpoint = authenticate_oidc.value.user_info_endpoint
      }
    }
  }

  # Cannot use nested dynamic blocks with nested collection variables forward and target_groups
  # https://github.com/hashicorp/terraform/issues/32180
  # Module 4.1.0 is prine to this issue, and only works with aws provider <= 5.35

  # fixed-response
  dynamic "action" {
    for_each = var.action.fixed_response != null ? [var.action.fixed_response] : []

    content {
      type  = "fixed-response"
      order = var.action.order

      fixed_response {
        content_type = action.value.content_type
        message_body = action.value.message_body
        status_code  = action.value.status_code
      }
    }
  }

  # forward
  dynamic "action" {
    for_each = var.action.target_group_arn != null ? [1] : []
    content {
      type  = "forward"
      order = var.action.order

      target_group_arn = var.action.target_group_arn
    }
  }

  # weighted forward
  dynamic "action" {
    for_each = var.action.forward != null ? [var.action.forward] : []

    content {
      type  = "forward"
      order = var.action.order

      forward {
        dynamic "target_group" {
          for_each = coalesce(action.value.target_groups, [])

          content {
            arn    = target_group.value.arn
            weight = target_group.value.weight
          }
        }

        dynamic "stickiness" {
          for_each = action.value.stickiness != null ? [action.value.stickiness] : []

          content {
            duration = stickiness.value.duration
            enabled  = stickiness.value.enabled
          }
        }
      }
    }
  }

  # redirect
  dynamic "action" {
    for_each = var.action.redirect != null ? [var.action.redirect] : []

    content {
      type  = "redirect"
      order = var.action.order

      redirect {
        status_code = action.value.status_code
        host        = action.value.host
        path        = action.value.path
        port        = action.value.port
        protocol    = action.value.protocol
        query       = action.value.query
      }
    }
  }

  dynamic "condition" {
    for_each = var.conditions

    content {
      dynamic "host_header" {
        for_each = try([condition.value.host_header], [])

        content {
          values = host_header.value.values
        }
      }

      dynamic "http_header" {
        for_each = try([condition.value.http_header], [])

        content {
          http_header_name = http_header.value.http_header_name
          values           = http_header.value.values
        }
      }

      dynamic "http_request_method" {
        for_each = try([condition.value.http_request_method], [])

        content {
          values = http_request_method.value.values
        }
      }

      dynamic "path_pattern" {
        for_each = try([condition.value.path_pattern], [])

        content {
          values = path_pattern.value.values
        }
      }

      dynamic "query_string" {
        for_each = try([condition.value.query_string], [])

        content {
          key   = try(query_string.value.key, null)
          value = query_string.value.value
        }
      }

      dynamic "source_ip" {
        for_each = try([condition.value.source_ip], [])

        content {
          values = source_ip.value.values
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags       = merge(var.module_tags, var.tags)
  depends_on = [var.module_depends_on]
}
