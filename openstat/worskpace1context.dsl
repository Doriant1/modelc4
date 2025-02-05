workspace {

    model {
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG pour les services clients."

        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations."
        
        pex = softwareSystem "PEX" "Portail d’Exploitation pour la France."
        ece = softwareSystem "ECE" "Espace Client Entreprise pour la France."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        arg = softwareSystem "ARG" "Interface interne pour les RSC et CSM."

        atos = softwareSystem "ATOS" "Assure le développement de l'application et le support niveau 2/3."
        nmsa = softwareSystem "NMSA" "Fournit le support matériel et système."
        asgen = softwareSystem "ASGEN" "Supervision système et applicative pour les composants critiques d'OpenStat."
        witbe = softwareSystem "Witbe" "Supervision des services via des sondes."

        user_fr -> pex "Consulte les rapports via"
        user_fr -> ece "Consulte les rapports via"
        user_int -> mss "Consulte les rapports via"
        rsc_csm -> arg "Accède aux rapports et administre l'application via"

        pex -> openstat "Fournit l'accès aux rapports générés par"
        ece -> openstat "Fournit l'accès aux rapports générés par"
        mss -> openstat "Fournit l'accès aux rapports générés par"
        arg -> openstat "Fournit l'accès aux rapports générés par"

        atos -> openstat "Développe et maintient"
        nmsa -> openstat "Fournit le support pour"
        asgen -> openstat "Supervise"
        witbe -> openstat "Supervise les services de"
    }

    views {
        systemContext openstat {
            include *
            autolayout lr
            title "Vue du Contexte Système pour OpenStat"
            description "Cette vue illustre les acteurs externes et les systèmes interagissant avec OpenStat."
        }

        styles {
            element "Person" {
                background #08427b
                color #ffffff
                shape person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
        }
    }
}
