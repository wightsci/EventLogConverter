# EventLogConverter
[![Build Status](https://dev.azure.com/wightsci/GitHub%20Repos/_apis/build/status/wightsci.EventLogConverter?branchName=master)](https://dev.azure.com/wightsci/GitHub%20Repos/_build/latest?definitionId=1&branchName=master)

A module to take Windows Event Log entries and make them easier to query and generally mine data from.

## What does this do?

The idea is to take the nested data structures of a typical Windows Event and make them flat, so that all of the useful properties are easily accessible via standard
PowerShell techniques, such as ``Where-Object``, ``Group-Object`` and ``Select-Object``.

Given the many varied log structures used by the Windows Event log, some compromises have had to be made.

Compare the structure of:

```xml
<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'>
    <System>
        <Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-A5BA-3E3B0328C30D}'/>
        <EventID>4624</EventID>
        <Version>2</Version>
        <Level>0</Level>
        <Task>12544</Task>
        <Opcode>0</Opcode>
        <Keywords>0x8020000000000000</Keywords>
        <TimeCreated SystemTime='2019-06-06T09:54:39.488885200Z'/>
        <EventRecordID>245041</EventRecordID>
        <Correlation ActivityID='{D8BF886D-19F4-0000-8288-BFD8F419D501}'/>
        <Execution ProcessID='584' ThreadID='2760'/>
        <Channel>Security</Channel>
        <Computer>WIN-90CID1J2CS5.carisbrookelabs.local</Computer>
        <Security/>
    </System>
    <EventData>
        <Data Name='SubjectUserSid'>S-1-0-0</Data>
        <Data Name='SubjectUserName'>-</Data>
        <Data Name='SubjectDomainName'>-</Data>
        <Data Name='SubjectLogonId'>0x0</Data>
        <Data Name='TargetUserSid'>S-1-5-18</Data>
        <Data Name='TargetUserName'>WIN-90CID1J2CS5$</Data>
        <Data Name='TargetDomainName'>CARISBROOKELABS.LOCAL</Data>
        <Data Name='TargetLogonId'>0x1c8cb49</Data>
        <Data Name='LogonType'>3</Data>
        <Data Name='LogonProcessName'>Kerberos</Data>
        <Data Name='AuthenticationPackageName'>Kerberos</Data>
        <Data Name='WorkstationName'>-</Data>
        <Data Name='LogonGuid'> { 1B89B270-CD8E-CD3F-22E5-1DB88383FB10 }</Data>
        <Data Name='TransmittedServices'>-</Data>
        <Data Name='LmPackageName'>-</Data>
        <Data Name='KeyLength'>0</Data>
        <Data Name='ProcessId'>0x0</Data>
        <Data Name='ProcessName'>-</Data>
        <Data Name='IpAddress'>fe80::7180:bb16:703d:28ca</Data>
        <Data Name='IpPort'>52564</Data>
        <Data Name='ImpersonationLevel'>%%1840</Data>
        <Data Name='RestrictedAdminMode'>-</Data>
        <Data Name='TargetOutboundUserName'>-</Data>
        <Data Name='TargetOutboundDomainName'>-</Data>
        <Data Name='VirtualAccount'>%%1843</Data>
        <Data Name='TargetLinkedLogonId'>0x0</Data>
        <Data Name='ElevatedToken'>%%1842</Data>
    </EventData>
</Event>
```

To:

```
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
Querying the XML version is possible, but not straightforward. The second version is a normal PowerShell object.