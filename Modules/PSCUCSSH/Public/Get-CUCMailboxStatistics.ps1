Function Get-CUCMailboxStatistics {
<#
.SYNOPSIS
Get Cisco Unity Mailbox Statistics over SSH
 
.DESCRIPTION
Queries the Cisco Unity Server over SSH and returns the results as an object.
Query run:
/* Formatted on 2/15/2019 12:11:21 PM (QP5 v5.287) */
SELECT alias,
       COUNT (*) AS TotalMessages,
       SUM (CASE WHEN deleted = '0' THEN 1 ELSE 0 END) AS Inbox,
       SUM (CASE WHEN deleted = '1' THEN 1 ELSE 0 END) AS Deleted,
       SUM (CASE WHEN seen = '0' THEN 1 ELSE 0 END) AS Unread,
       SUM (CASE WHEN seen = '1' THEN 1 ELSE 0 END) AS Read,
       SUM (CASE WHEN archived = '0' THEN 1 ELSE 0 END) AS Archived,
       vw_mailbox.bytesize,
       vw_mailbox.warning,
       vw_mailbox.send,
       vw_mailbox.receive
  FROM vw_message, vw_mailbox, unitydirdb:vw_mailbox, unitydirdb:vw_user 
  where vw_message.mailboxobjectid=vw_mailbox.mailboxobjectid and 
        vw_mailbox.mailboxobjectid in (select mailboxid 
                                        from vw_mailbox 
                                            where unitydirdb:vw_user.objectid = unitydirdb:vw_mailbox.userobjectid) 
    group by alias, vw_mailbox.bytesize,vw_mailbox.warning,vw_mailbox.send, vw_mailbox.receive


These properties are converted to MB for human readability.
bytesize
warning
send
receive

.EXAMPLE
Get-CUCMailboxStatistics

alias             totalmessages inbox deleted unread read archived bytesize warning send receive
-----             ------------- ----- ------- ------ ---- -------- -------- ------- ---- -------
aaaaaaaa@demo.com 5             4     1       1      4    5        1        31      32   34
aaaaa@demo.com    2             0     2       0      2    2        0        31      32   34
operator          6             6     0       0      6    6        1        31      32   34
aaaaaaa@demo.com  7             6     1       0      7    7        1        31      32   34
aaaaa@demo.com    6             5     1       0      6    6        1        31      32   34
aaaaaaa@demo.com  14            14    0       0      14   14       2        31      32   34
aaaaaaaa@demo.com 1             1     0       0      1    1        0        31      32   34
aaaaaaa@demo.com  6             6     0       1      5    6        1        31      32   34
#>
    $TypeName = 'Cisco.UnityConnection.CUCMailboxStatistics'
    $SSHstream = $Script:SSHstream

    $query = "run cuc dbquery unitymbxdb1 select alias, count (*) as TotalMessages, sum(case when deleted='0' then 1 else 0 end) as Inbox, sum(case when deleted='1' then 1 else 0 end) as Deleted, sum(case when seen='0' then 1 else 0 end) as Unread, sum(case when seen='1' then 1 else 0 end) as Read, sum(case when archived='0' then 1 else 0 end) as Archived, vw_mailbox.bytesize, vw_mailbox.warning, vw_mailbox.send, vw_mailbox.receive from vw_message, vw_mailbox, unitydirdb:vw_mailbox, unitydirdb:vw_user where vw_message.mailboxobjectid=vw_mailbox.mailboxobjectid and vw_mailbox.mailboxobjectid in (select mailboxid from vw_mailbox where unitydirdb:vw_user.objectid = unitydirdb:vw_mailbox.userobjectid) group by alias, vw_mailbox.bytesize,vw_mailbox.warning,vw_mailbox.send, vw_mailbox.receive"
    $SSHstream.WriteLine($query)

    start-sleep 10

    $read = $SSHstream.Read()

    $split = ($read -split "`n")

    $results = $split | select-string "run cuc dbquery unitymbxdb1" -Context 0, $($split.count) | 
        foreach-object { $_.context.postcontext }

    $content = $results | select-string "--" -context 0, ($results.count) | 
        foreach-object { $_.context.postcontext }

    $headers = ($results[1].Trim(" ") -replace ("\b *\B")).split(" ").trim()

    $content = ($content.Trim(" ") -replace ("\b *\B"))

    $content[0..$($content.count - 4)] | ForEach-Object { 
        $hash = [ordered]@{
            $headers[0]  = $_.split(" ")[0].trim()
            $headers[1]  = [int]$_.split(" ")[1].trim()
            $headers[2]  = [int]$_.split(" ")[2].trim()
            $headers[3]  = [int]$_.split(" ")[3].trim()
            $headers[4]  = [int]$_.split(" ")[4].trim()
            $headers[5]  = [int]$_.split(" ")[5].trim()
            $headers[6]  = [int]$_.split(" ")[6].trim()
            $headers[7]  = [math]::round([int]$_.split(" ")[7].trim() / 1MB)
            $headers[8]  = [math]::round([int]$_.split(" ")[8].trim() / 1MB)
            $headers[9]  = [math]::round([int]$_.split(" ")[9].trim() / 1MB)
            $headers[10] = [math]::round([int]$_.split(" ")[10].trim() / 1MB)
        }
        $objects = new-object -typename psobject -property $hash
        
        return Format-Result -results $objects -TypeName $TypeName
    }
}