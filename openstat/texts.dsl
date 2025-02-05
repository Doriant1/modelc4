workspace "OpenStat - Vues Contexte et Conteneur" "Application de reporting pour les réseaux, services voix et vidéo, et services clients." {

    model {
        // === Acteurs Externes ===
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG pour les services clients."
        atos = person "ATOS" "Développe et maintient l'application OpenStat."

        // === Système Central ===
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations." {
            refura = container "RefURA" "Gestion des authentifications et autorisations." "Java Spring Boot"
            openreport = container "OpenReport" "Calcul des KPI et analyses." "Java"
        }
    }

    // === Déploiement ===
    deployment "Production" {
        deploymentNode "Auth Server Cluster" "Cluster haute disponibilité pour l'authentification" "Linux / Kubernetes" {
            containerInstance refura
        }
        
        deploymentNode "Reporting Server Cluster" "Cluster de calcul et d'analyse des KPI" "Linux / Kubernetes" {
            containerInstance openreport
        }
    }

    // === Vues ===
    views {
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue du Contexte Système pour OpenStat"
        }

        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
        }

        component refura {
            include *
            autoLayout tb
            title "Vue Composant - RefURA"
        }

        component openreport {
            include *
            autoLayout tb
            title "Vue Composant - OpenReport"
        }

        deployment "Production" {
            include *
            autoLayout tb
            title "Vue de Déploiement - OpenStat"
        }
    }
}
