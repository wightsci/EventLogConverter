[CmdletBinding()]
Param()
Function ConvertTo-EvtObject  {
    [CmdletBinding()]
    Param (
    [parameter(ValueFromPipelineByPropertyName,ValueFromPipeline,Mandatory=$true)]
    [Object[]]$InputObject
    )
    Process {
        [System.Collections.ArrayList]$Objects = @()
        $InputObject | ForEach-Object { 
            $xdoc =  [xml]$_.ToXML()
            $obj = New-Object PSObject
            #create NoteProperty for each System node - check for attributes and create
            #a new property using a <node><attribute> syntax
            $xdoc.Event.System.ChildNodes | ForEach-Object {
                if ($_.HasAttributes) {
                    $parentName  = $_.LocalName
                    $_.Attributes | ForEach-Object {
                        $obj | Add-Member -MemberType NoteProperty -Name "$($parentName)$($_.Name)" -Value $_.'#text'
                    }
                }
                if ($_.'#text') {
                    #add the Text node if present
                    $obj | Add-Member -MemberType NoteProperty -Name $_.LocalName -Value $_.InnerText 
                }
            }
            #check for named EventData node(s)
            $xdoc.Event.EventData  | ForEach-Object {
                if ($_.Name -ne $_.LocalName) {
                    $PropertyName = "EventDataName"
                    $PropertyValue = $_.Name
                    $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue
                }
            }
            #create NoteProperty for each EventData.Data node
            $DataCounter = 0
            if ($xdoc.Event.EventData) {        
                $xdoc.Event.EventData.Data | ForEach-Object {
                    if ($_.Name) {
                        $PropertyName = $_.Name
                        if ($obj.$PropertyName) {
                            $PropertyName = "$($_.Name)01"
                        }
                        $PropertyValue = $_.innerText
                    }
                    else {
                        #for unnamed Data nodes, use a numeric counter
                        $PropertyName = "Data$($DataCounter.toString('00'))"
                        $PropertyValue =  $_.toString()
                        $DataCounter += 1
                    }
                    $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue
                }
            }
            #if there is a Userdata node, try to handle that
            if ($xdoc.Event.UserData) {        
                $xdoc.Event.UserData | ForEach-Object { 
                    $PropertyName = 'UserData'
                    if ($_.ChildNodes) {
                        $ParentName =  $_.LocalName
                        $_.ChildNodes | ForEach-Object {
                            $PropertyName = "$ParentName$($_.localName)"
                            if ($_.ChildNodes) {
                                $ParentName = $_.LocalName
                                $_.ChildNodes | ForEach-Object {
                                    $PropertyName = "$ParentName$($_.localName)"
                                    $PropertyValue = $_.InnerXML
                                    $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue 
                                }   
                            } else {
                                $PropertyValue = $_.InnerXML
                                $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue 
                            }
                        }
                    } 
                    else {
                        $PropertyValue = $_.InnerXML
                        $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue 
                    }
                }
            }
            #if there is a Binary node, try to handle that
            if ($xdoc.Event.EventData.Binary) { 
                $PropertyName = "Binary"
                $PropertyValue =  $xdoc.Event.EventData.Binary.toString()
                $obj | Add-Member -MemberType NoteProperty -Name $PropertyName -Value $PropertyValue
            }
            [Void]$Objects.Add($obj)
        }
        $Objects
    }
}

