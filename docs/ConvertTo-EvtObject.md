---
external help file: EventLogConverter-help.xml
Module Name: EventLogConverter
online version:
schema: 2.0.0
---

# ConvertTo-EvtObject

## SYNOPSIS
This cmdlet converts Event objects into flat Evt objects

## SYNTAX

```
ConvertTo-EvtObject [-InputObject] <Object[]> [<CommonParameters>]
```

## DESCRIPTION
This cmdlet takes input of standard event records as produced by Get-WinEvent and converts them into a flatter object structure that is easier to query and to extract data from.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-WinEvent -LogName Security -FilterXPath "*[System[EventID=4624]]" -MaxEvents 1 | ConvertTo-EvtObject


ProviderName              : Microsoft-Windows-Security-Auditing
ProviderGuid              : {54849625-5478-4994-A5BA-3E3B0328C30D}
EventID                   : 4624
Version                   : 2
Level                     : 0
Task                      : 12544
Opcode                    : 0
Keywords                  : 0x8020000000000000
TimeCreatedSystemTime     : 2019-06-06T09:54:39.488885200Z
EventRecordID             : 245041
CorrelationActivityID     : {D8BF886D-19F4-0000-8288-BFD8F419D501}
ExecutionProcessID        : 584
ExecutionThreadID         : 2760
Channel                   : Security
Computer                  : WIN-90CID1J2CS5.carisbrookelabs.local
SubjectUserSid            : S-1-0-0
SubjectUserName           : -
SubjectDomainName         : -
SubjectLogonId            : 0x0
TargetUserSid             : S-1-5-18
TargetUserName            : WIN-90CID1J2CS5$
TargetDomainName          : CARISBROOKELABS.LOCAL
TargetLogonId             : 0x1c8cb49
LogonType                 : 3
LogonProcessName          : Kerberos
AuthenticationPackageName : Kerberos
WorkstationName           : -
LogonGuid                 : {1B89B270-CD8E-CD3F-22E5-1DB88383FB10}
TransmittedServices       : -
LmPackageName             : -
KeyLength                 : 0
ProcessId                 : 0x0
ProcessName               : -
IpAddress                 : fe80::7180:bb16:703d:28ca
IpPort                    : 52564
ImpersonationLevel        : %%1840
RestrictedAdminMode       : -
TargetOutboundUserName    : -
TargetOutboundDomainName  : -
VirtualAccount            : %%1843
TargetLinkedLogonId       : 0x0
ElevatedToken             : %%1842
```

In this example we extract a single 4624 event from the security log and pass it to ConvertTo-EvtObject over the pipeline.

## PARAMETERS

### -InputObject
A standard Windows Event Log record, such as the output from Get-WinEvent

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
