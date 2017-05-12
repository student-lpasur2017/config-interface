# Affichage des interfaces avec leurs index
Get-NetAdapter

$confinterface="o"
$n=0
$confdnsclient="o"

# configurer les interfaces tant que la var reste a "o"
while ($confinterface -eq "o") {
    # initialisation des variables
    $numIntIndex=Read-Host -Prompt "Quel est le numéro d'interface à configurer "
    $ipv4=Read-Host -Prompt "Quelle est l'adresse IP que voulez vous attribuer "
    $maskcidr=Read-Host -Prompt "Quel est le masque notation CIDR voulez vous ajouter "
    $gateway=Read-Host -Prompt "Quelle est la passerelle à ajouter "
    $namedomain=Read-Host -Prompt "Voulez vous ajouter une adresse DNS au serveur ? [o]ui ou [n]on "

    # Desactive l'acceptation d'une configuration ip dynamique sur l'interface
    Set-NetIPInterface -InterfaceIndex $numIntIndex -Dhcp Disabled
    # Active l'acceptation d'une configuration ip dynamique sur l'interface
    # Set-NetIPAddress -InterfaceIndex $numIntIndex -Dhcp Enabled

    # Configure l'interface
    New-NetIPAddress -InterfaceIndex $numIntIndex -IPAddress $ipv4 -PrefixLength $maskcidr #-DefaultGateway $gateway

    # Condition si adresse DNS doit être configuré ou non
    if ($confdnsclient -eq "o") {
        $n=Read-Host -Prompt "Combien voulez-vous affecter d'adresse DNS au serveur "
        # Tant que "n", pour le nombre d'adresse DNS à saisir, n'atteind pas "0", alors on saisit des adresses DNS
        while ($n -ne 0){
            #Write-Output "Saisir l'adresse DNS numéro $n "
	    $namedomain=Read-Host -Prompt "Saisir l'adresse DNS numero $n"
	    Set-DnsClient -InterfaceIndex $numIntIndex -ConnectionSpecificSuffix $namedomain
	    # Il faut que $n soit converti en nombre
            # $n--
	    $n=$n-1
        }        
    }

    # Demande a l'utilisateur s'il veut configurer des interfaces
    $confinterface=Read-Host -Prompt "Voulez-vous configurer une nouvelle interface ? [o]ui ou [n]on "
}

# Desactive le pare-feu sur le serveur pour laisser passer protocole icmp et autres
Set-NetFirewallProfile -Profile * -Enabled False
