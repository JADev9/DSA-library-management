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
