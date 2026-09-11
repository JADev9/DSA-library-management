import ballerina/http;
import ballerina/io;

http:Client libraryClient = check new ("http://localhost:8080/library");

public function main() returns error? {
    while true {
        io:println("\n=== Library Management System ===");
        io:println("1. View all assets");
        io:println("2. Add a new asset");
        io:println("3. Delete an asset");
        io:println("4. View one asset");
        io:println("5. Assets by institution");
        io:println("6. View overdue");
        io:println("7. Add a component");
        io:println("8. View institutions"); 
        io:println("9. Add a schedule");
        io:println("10. Add an institution");     
        io:println("0. Exit");

        string choice = io:readln("Choose an option: ");

        if choice == "1" {
            check viewAllAssets();
        } else if choice == "2" {
            check addAsset();
        } else if choice == "3" {
            check deleteAsset();
        } else if choice == "4" {
            check viewOneAsset();
        } else if choice == "5" {
            check viewByInstitution();
        } else if choice == "6" {
            check viewOverdue();
        } else if choice == "7" {
            check addComponent();
        } else if choice == "8" {
            check viewInstitutions();
        } else if choice == "9" {
            check addSchedule();
        } else if choice == "10" {
            check addInstitution();       
        } else if choice == "0" {
            io:println("Goodbye.");
            break;
        } else {
            io:println("Invalid option.");
        }
    }
}

function viewAllAssets() returns error? {
    Asset[] assets = check libraryClient->get("/assets");

    if assets.length() == 0 {
        io:println("No assets found.");
        return;
    }

    foreach Asset asset in assets {
        io:println(asset.assetTag + " | " + asset.name + " | " + asset.status);
    }
}

function addAsset() returns error? {
    Asset newAsset = {
        assetTag: io:readln("Asset tag: "),
        name: io:readln("Name: "),
        description: io:readln("Description: "),
        institution: io:readln("Institution: "),
        site: io:readln("Site: "),
        status: io:readln("Status: "),
        dateAcquired: io:readln("Date acquired (YYYY-MM-DD): ")
    };
   
       Asset created = check libraryClient->post("/assets", newAsset);
       io:println("Created: " + created.assetTag);
      }
      function deleteAsset() returns error? {
         string tag = io:readln("Asset tag to delete: ");
         string response = check libraryClient->delete("/assets/" + tag);
         io:println(response);
      }

      function viewOneAsset() returns error? {
         string tag = io:readln("Asset tag: ");
         Asset asset = check libraryClient->get("/assets/" + tag);
         io:println(asset.assetTag + " | " + asset.name + " | " + asset.status);
         io:println("Institution: " + asset.institution + " | Site: " + asset.site);
      

}
function viewByInstitution() returns error? {
    string institution = io:readln("Institution name: ");
    Asset[] assets = check libraryClient->get("/institutions/" + institution + "/assets");

    if assets.length() == 0 {
        io:println("No assets found for " + institution);
        return;
    }

    foreach Asset asset in assets {
        io:println(asset.assetTag + " | " + asset.name + " | " + asset.site);
    }
}

function viewOverdue() returns error? {
    Asset[] assets = check libraryClient->get("/assets/overdue");

    if assets.length() == 0 {
        io:println("Nothing overdue.");
        return;
    }

    foreach Asset asset in assets {
        io:println("OVERDUE: " + asset.assetTag + " | " + asset.name);
    }
}
function addComponent() returns error? {
    string tag = io:readln("Asset tag: ");

    Component newComponent = {
        compId: io:readln("Component ID: "),
        name: io:readln("Component name: "),
        description: io:readln("Description: ")
    };

    Asset updated = check libraryClient->post("/assets/" + tag + "/components", newComponent);
    io:println("Component added. Asset now has " + updated.components.length().toString() + " component(s).");
}

function viewInstitutions() returns error? {
    Institution[] institutions = check libraryClient->get("/institutions");

    if institutions.length() == 0 {
        io:println("No institutions found.");
        return;
    }

    foreach Institution inst in institutions {
        io:println(inst.institutionId + " | " + inst.name);
    }
}
function addSchedule() returns error? {
    string tag = io:readln("Asset tag: ");

    Schedule newSchedule = {
        scheduleId: io:readln("Schedule ID: "),
        'type: io:readln("Type (MAINTENANCE or BOOKING): "),
        dueDate: io:readln("Due date (YYYY-MM-DD): "),
        description: io:readln("Description: ")
    };

    Asset updated = check libraryClient->post("/assets/" + tag + "/schedules", newSchedule);
    io:println("Schedule added. Asset now has " + updated.schedules.length().toString() + " schedule(s).");
}

function addInstitution() returns error? {
    Institution newInstitution = {
        institutionId: io:readln("Institution ID: "),
        name: io:readln("Institution name: "),
        sites: []
    };

    Institution created = check libraryClient->post("/institutions", newInstitution);
    io:println("Created institution: " + created.name);
}
