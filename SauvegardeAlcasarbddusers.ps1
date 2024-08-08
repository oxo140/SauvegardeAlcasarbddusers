#Pause de sécurité le temps de la connexion
# Spécifiez les informations d'identification
$nomUtilisateur = "Login"
$motDePasse = ConvertTo-SecureString -String "Mot de passe" -AsPlainText -Force
$credentials = New-Object -TypeName PSCredential -ArgumentList $nomUtilisateur, $motDePasse

# Spécifiez le chemin réseau et le nom de lecteur
$cheminReseau = "\\sshfs\login@ipduserveur"
$nomLecteur = "Z"

# Connectez le lecteur réseau avec les informations d'identification
New-PSDrive -Name $nomLecteur -PSProvider FileSystem -Root $cheminReseau -Credential $credentials -Persist

Get-ChildItem -Path $nomLecteur


Start-Sleep -Seconds 10

# Cette partie ci-dessous corcerne la sauvegarde des fichiers sql

# Le chemin du disque qui vas copier la base de données
$sourcePath = "Z:\sauvegarde\*"

# Le chemin de destination de la copie
$destinationPath = "C:\sauvegarde"

# La copie
Copy-Item $sourcePath $destinationPath -Force

# Pause de sécurité le temps de la connexion
# Chemin du répertoire à nettoyer
$repertoire = "C:\sauvegarde"

# Récupération de la date actuelle
$dateActuelle = Get-Date

# Définition de l'intervalle de temps (1 mois)

$intervalle = New-TimeSpan -Days 30
# Calcul de la date limite (il y a plus d'un mois)
$dateLimite = $dateActuelle - $intervalle

# Récupération de la liste des fichiers dans le répertoire
$fichiers = Get-ChildItem -Path $repertoire

# Parcours de la liste des fichiers
foreach ($fichier in $fichiers) {
    # Vérification de la date de dernière modification
    if ($fichier.LastWriteTime -lt $dateLimite) {
        # Suppression du fichier
        Remove-Item -Path $fichier.FullName -Force
        Write-Output "Supprimé : $($fichier.FullName)"
    }
}

