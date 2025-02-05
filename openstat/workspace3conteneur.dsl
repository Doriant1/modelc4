workspace "OpenStat" "Application de reporting pour les réseaux, services voix et vidéo, et services clients" {

    model {
        // Acteurs Externes
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface ARG pour la gestion des services clients."

        // Portails d'accès
        pex = softwareSystem "PEX" "Portail d’Exploitation (France)."
        ece = softwareSystem "ECE" "Espace Client Entreprise (France)."
        mss = softwareSystem "MSS" "My Service Space (International)."
        arg = softwareSystem "ARG" "Interface interne dédiée aux RSC et CSM."

        // Système Central
        openstat = softwareSystem "OpenStat" "Application de reporting pour l'analyse des performances réseau, voix et vidéo." {
            
            // Conteneurs internes
            dashboard = container "OpenDashBoard" "Interface Web pour la visualisation des rapports." "Angular/React"
            refura = container "RefURA" "Gestion des authentifications et autorisations." "Java Spring Boot"
            openreport = container "OpenReport" "Calcul des KPI et analyses." "Python/Scala"
            cassandra = container "Cassandra" "Stockage des données collectées." "NoSQL Database"
            nas = container "NAS" "Stockage temporaire des fichiers et données collectées." "Stockage NFS"
            proxycollector = container "ProxyCollector" "Collecte des données des sources externes." "Python"
            opencollector = container "OpenCollector" "Rassemble et transfère les données collectées." "Java"
            openscheduler = container "OpenScheduler" "Ordonne et planifie les tâches et flux." "Java Quartz Scheduler"
            refreport = container "RefReport / RefObject" "Référentiel des KPIs et des étapes de calculs." "Java"
            mom = container "MOM" "Bus d’ordre SOA pour la communication entre modules." "ActiveMQ/Kafka"
        }

        // Définition des interactions
        user_fr -> pex "Consulte les rapports via"
        user_fr -> ece "Consulte les rapports via"
        user_int -> mss "Consulte les rapports via"
        rsc_csm -> arg "Accède aux rapports et administre les services via"

        pex -> openstat "Demande d'accès aux rapports"
        ece -> openstat "Demande d'accès aux rapports"
        mss -> openstat "Demande d'accès aux rapports"
        arg -> openstat "Fournit l'accès aux outils d’administration"

        // Interactions entre Conteneurs
        dashboard -> refura "Demande d'authentification"
        refura -> dashboard "Réponse d'authentification"
        dashboard -> openreport "Demande d’accès aux rapports"
        openreport -> cassandra "Lit et écrit les données"
        openreport -> nas "Stockage temporaire"
        proxycollector -> opencollector "Transfert des données collectées"
        opencollector -> nas "Stocke les données brutes"
        openreport -> refreport "Consulte les KPIs et règles de calcul"
        openscheduler -> mom "Ordonne les flux"
        mom -> openreport "Envoie les ordres de calculs"
    }

    views {
        // Vue Contexte
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue Contexte - OpenStat"
            description "Vue globale des acteurs externes et des interactions avec OpenStat."
        }

        // Vue Conteneur
        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
            description "Détails des composants internes et interactions d'OpenStat."
        }

        // ✅ Application des styles
        styles {
            element "Person" {
                background #ffcc00
                color #000000
                shape person
            }

            element "Software System" {
                background #438dd5
                color #ffffff
                shape roundedBox
            }

            element "Container" {
                background #85bbf0
                color #ffffff
            }
        }
    }
}
