
-ArtifactoryUrl http://artifactory.domainname.com/artifactory/Reponame/${bamboo.planRepository.branchName}/
-user admin 
-Pass AP5c1ndxgnh7MvJsX7Y6eLPEfte
-packageName ${bamboo.planKey}
-NumOfPackageRetain 1

e.g 



 [cmdletBinding()]
 param
 (
 [parameter(Mandatory =$true)]
 [ValidateNotNullOrEmpty()]
 $ArtifactoryUrl,
 [parameter(Mandatory =$true)]
 [ValidateNotNullOrEmpty()]
 $user,
 [parameter(Mandatory =$true)]
 [ValidateNotNullOrEmpty()]
 $Pass,
 [parameter(Mandatory =$true)]
 [ValidateNotNullOrEmpty()]
 $packageName,
 [parameter(Mandatory =$true)]
 [ValidateNotNullOrEmpty()]
 $NumOfPackageRetain
 )

  

  $secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential($user,$secpasswd)

  Invoke-WebRequest -OutFile data.html $ArtifactoryUrl -Credential $cred
  $outputgrep=Get-Content .\data.html | Select-String -Pattern $packageName

   

   $testArray = [System.Collections.ArrayList]@()
   foreach($i in $outputgrep)
   { 
   $string=$i
   $delim = ">","/"
   $split=$string -Split {$delim -contains $_}

   $item=$split[2]

   $arrayID = $testArray.Add($item)

   }


   #echo $testArray | group length | sort name | foreach {$_.group | sort}
   $sortedElement = $testArray | group length | sort name | foreach {$_.group | sort}

   $count=$testArray.Count


   if($count -le $NumOfPackageRetain){
   Write-Host "=============== Nothing to Do ================"
   exit 1
   }

    

    For ($j=0; $j -lt $count-$NumOfPackageRetain; $j++) {
    Write-Host "Deleting $j element that is " $sortedElement[$j]
    $deleteItem= $sortedElement[$j]
    Invoke-WebRequest -Method Delete -Uri $ArtifactoryUrl$deleteItem -Credential $cred
    }


