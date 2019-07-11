#$events = Get-WinEvent -LogName Application -FilterXPath "*[System[EventID=0]]" -MaxEvents 1
#$events = Get-WinEvent -LogName Security -FilterXPath "*[System[EventID=4624]]" -MaxEvents 1
#$events = Get-WinEvent -LogName Application -FilterXPath "*[System[EventID=1000]]" -MaxEvents 1
#$events = Get-WinEvent -LogName Application -FilterXPath "*[UserData]" -MaxEvents 1000

$ModuleRoot = $PSScriptRoot.Replace('\Tests','') 
Import-Module "$ModuleRoot\EventLogConverter" -Force
Describe "EventLogConverter Tests" {
    #Sample Event representing a power-on. Should be present on all machines.
    $sampleEvent = Get-WinEvent -LogName 'System' -FilterXPath "*[System[EventID=12 and Provider[@Name='Microsoft-Windows-Kernel-General']]]" -MaxEvents 1 | ConvertTo-EvtObject
    It "Returns 1 Event ID 12 event (Kernel-General)" {            
        ($sampleEvent | Measure-Object) | Should -HaveCount 1
    }
    It "Event has 'ProviderName' property set to 'Microsoft-Windows-Kernel-General'" {
        $sampleEvent.ProviderName  | Should be 'Microsoft-Windows-Kernel-General'
    }
    It "Event has EventID 12" {
        $sampleEvent.EventID | Should Be '12'
    }
}