// service.bal
// The RESTful API for the Library and Resource Management System.

import ballerina/http;
import ballerina/time;

map<Asset> assetStore = {};

service /library on new http:Listener(8080) {


    // CREATE — POST /library/assets
    resource function post assets(@http:Payload Asset newAsset)
            returns Asset|http:Conflict|http:BadRequest {

        if newAsset.assetTag.trim() == "" {
            return <http:BadRequest>{body: "assetTag is required"};
        }
        if assetStore.hasKey(newAsset.assetTag) {
            return <http:Conflict>{
                body: string `Asset with tag ${newAsset.assetTag} already exists`
            };
        }
        assetStore[newAsset.assetTag] = newAsset;
        return newAsset;
    }

    
    // READ ALL — GET /library/assets
    resource function get assets() returns Asset[] {
        return assetStore.toArray();
    }


    // READ ONE — GET /library/assets/{assetTag}
    resource function get assets/[string assetTag]()
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }
        return assetStore.get(assetTag);
    }


    // UPDATE — PUT /library/assets/{assetTag}
    resource function put assets/[string assetTag](@http:Payload Asset updated)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        assetStore[assetTag] = updated;
        return updated;
    }


    // DELETE — DELETE /library/assets/{assetTag}
    resource function delete assets/[string assetTag]()
            returns http:Ok|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        _ = assetStore.remove(assetTag);

        return <http:Ok>{
            body: "Asset deleted successfully"
        };
    }

   
    // GET /library/institutions/{institution}/assets
    resource function get institutions/[string institution]/assets(string? site)
            returns Asset[] {

        Asset[] results = [];

        foreach Asset asset in assetStore.toArray() {
            if asset.institution == institution {
                if site is () || asset.site == site {
                    results.push(asset);
                }
            }
        }

        return results;
    }


    // GET /library/assets/overdue
    resource function get assets/overdue() returns Asset[] {

        Asset[] overdueAssets = [];

        time:Utc currentTime = time:utcNow();
        string today = time:utcToString(currentTime).substring(0, 10);

        foreach Asset asset in assetStore.toArray() {
            foreach Schedule schedule in asset.schedules {
                if schedule.dueDate < today {
                    overdueAssets.push(asset);
                    break;
                }
            }
        }

        return overdueAssets;
   }

   resource function post assets/[string assetTag]/schedules(@http:Payload Schedule newSchedule)
            returns Asset|http:NotFound{
              
        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                   body: string `No asset with tag ${assetTag}`
           };
       }
       Asset asset = assetStore.get(assetTag);
       asset.schedules.push(newSchedule);
       assetStore[assetTag] = asset;

       return asset;
    }
    resource function delete assets/[string assetTag]/schedules/[string scheduleId]()
            returns Asset|http:NotFound{

       if !assetStore.hasKey(assetTag){
           return <http:NotFound>{
               body: string `No asset with tag ${assetTag}`
      };
    }

      Asset asset = assetStore.get(assetTag);
      asset.schedules = asset.schedules.filter(s => s.scheduleId != scheduleId);
      assetStore[assetTag] = asset;

      return asset;
    }

    resource function post assets/[string assetTag]/components(@http:Payload Component newComponent)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        Asset asset = assetStore.get(assetTag);
        asset.components.push(newComponent);
        assetStore[assetTag] = asset;

        return asset;
    }

    resource function delete assets/[string assetTag]/components/[string compId]()
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        Asset asset = assetStore.get(assetTag);
        asset.components = asset.components.filter(c => c.compId != compId);
        assetStore[assetTag] = asset;

        return asset;
    }
}
      Asset asset = assetStore.get(assetTag);
      asset.schedules = asset.schedules.filter(s => s.scheduleId != scheduleId);
      assetStore[assetTag] = asset;

      return asset;
    }

    resource function post assets/[string assetTag]/components(@http:Payload Component newComponent)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        Asset asset = assetStore.get(assetTag);
        asset.components.push(newComponent);
        assetStore[assetTag] = asset;

        return asset;
    }

    resource function delete assets/[string assetTag]/components/[string compId]()
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        Asset asset = assetStore.get(assetTag);
        asset.components = asset.components.filter(c => c.compId != compId);
        assetStore[assetTag] = asset;

        return asset;
    }
  }
}
        
    


