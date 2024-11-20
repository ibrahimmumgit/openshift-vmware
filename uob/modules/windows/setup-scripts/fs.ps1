$diskNumber = 1  # Specify the disk number where you want to create the partition
$partitionSize = 10GB  # Specify the size of the partition (e.g., 10GB)

# Initialize the disk
$disk = Get-Disk -Number $diskNumber
Initialize-Disk -InputObject $disk -PartitionStyle MBR

# Create a new partition on the specified disk
$partition = $disk | New-Partition -Size $partitionSize
$partition | Format-Volume -FileSystem NTFS -Confirm:$false

# Optional: Provide a volume label to the partition
#$volumeLabel = "New Partition"
#set-Partition -Partition $partition -NewDriveLetter F
#set-Partition -Partition $partition -NewFileSystemLabel $volumeLabel
get-partition -disknumber $diskNumber | set-partition -newdriveletter D

Set-Volume -DriveLetter "D" -NewFileSystemLabel "Data"
