#Run the script with the parameters specified -licensetFile  "Path to the csv licensetFile" -outputFile "Path to the output file"

param
(
	$licensetFile = $(throw 'Specify the csv licensetFile with licenses'),
		$outputFile = $(throw 'Specify the Output file')
)

trap
{
	write-error $_
	exit 1
}

$output = @()

foreach ($user in (Import-Csv $licensetFile | ?{ -not [string]::IsNullOrEmpty($_.Email) }))
{
	$email = $user.email

		if (-not (Get-ADUser -LDAPFilter "(mail=$email)" | where Enabled -eq $true))
		{
			$output += $email
		}
}

echo $output
set-content -Path $outputFile -Value $output -Encoding UTF8