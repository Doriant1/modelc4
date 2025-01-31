workspace {
  model {
    customer = person "Client" "Utilise le système"
    taskManagementSystem = softwareSystem "Système de Gestion de Tâches" "Gère les tâches"

    customer -> taskManagementSystem "Crée des tâches"
  }

  views {
    systemContext taskManagementSystem {
      include *
      autoLayout lr
    }

    styles {
      element "Person" {
        background "#FFDDC1"
        color "#000000"
      }
      element "SoftwareSystem" {
        background "#84CFFA"
        color "#000000"
      }
    }
  }
}
