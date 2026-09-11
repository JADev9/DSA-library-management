// service.bal
// The RESTful API for the Library and Resource Management System.

import ballerina/http;
import ballerina/time;

map<Asset> assetStore = {};
map<Institution> institutionStore = {};

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

    // POST /library/assets/{tag}/schedules — add a schedule
    resource function post assets/[string assetTag]/schedules(@http:Payload Schedule newSchedule)
            returns Asset|http:NotFound {

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

    // PUT /library/assets/{tag}/schedules/{scheduleId} — modify a schedule
    resource function put assets/[string assetTag]/schedules/[string scheduleId](@http:Payload Schedule updated)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);

        foreach int i in 0 ..< asset.schedules.length() {
            if asset.schedules[i].scheduleId == scheduleId {
                asset.schedules[i] = updated;
                assetStore[assetTag] = asset;
                return asset;
            }
        }

        return <http:NotFound>{body: string `No schedule ${scheduleId}`};
    }

    // DELETE /library/assets/{tag}/schedules/{scheduleId}
    resource function delete assets/[string assetTag]/schedules/[string scheduleId]()
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{
                body: string `No asset with tag ${assetTag}`
            };
        }

        Asset asset = assetStore.get(assetTag);
        asset.schedules = asset.schedules.filter(s => s.scheduleId != scheduleId);
        assetStore[assetTag] = asset;

        return asset;
    }

    // POST /library/assets/{tag}/components — add a component
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

    // DELETE /library/assets/{tag}/components/{compId}
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

    // POST /library/assets/{tag}/workorders — create a work order
    resource function post assets/[string assetTag]/workorders(@http:Payload WorkOrder newOrder)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);
        asset.workOrders.push(newOrder);
        assetStore[assetTag] = asset;

        return asset;
    }

    // PUT /library/assets/{tag}/workorders/{orderId} — update status
    resource function put assets/[string assetTag]/workorders/[string orderId](@http:Payload WorkOrderStatus update)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);

        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                asset.workOrders[i].status = update.status;
                assetStore[assetTag] = asset;
                return asset;
            }
        }

        return <http:NotFound>{body: string `No work order ${orderId}`};
    }

    // POST /library/assets/{tag}/workorders/{orderId}/tasks — add a task
    resource function post assets/[string assetTag]/workorders/[string orderId]/tasks(@http:Payload Task newTask)
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);

        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                asset.workOrders[i].tasks.push(newTask);
                assetStore[assetTag] = asset;
                return asset;
            }
        }

        return <http:NotFound>{body: string `No work order ${orderId}`};
    }

    // DELETE /library/assets/{tag}/workorders/{orderId}/tasks/{taskId}
    resource function delete assets/[string assetTag]/workorders/[string orderId]/tasks/[string taskId]()
            returns Asset|http:NotFound {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);

        foreach int i in 0 ..< asset.workOrders.length() {
            if asset.workOrders[i].orderId == orderId {
                asset.workOrders[i].tasks = asset.workOrders[i].tasks.filter(t => t.taskId != taskId);
                assetStore[assetTag] = asset;
                return asset;
            }
        }

        return <http:NotFound>{body: string `No work order ${orderId}`};
    }

    // POST /library/assets/{tag}/loan — mark asset as loaned out
    resource function post assets/[string assetTag]/loan()
            returns Asset|http:NotFound|http:Conflict {

        if !assetStore.hasKey(assetTag) {
            return <http:NotFound>{body: string `No asset with tag ${assetTag}`};
        }

        Asset asset = assetStore.get(assetTag);

        if asset.status != "AVAILABLE" {
            return <http:Conflict>{body: string `Asset ${assetTag} is not available (status: ${asset.status})`};
        }

        asset.status = "LOANED_OUT";
        assetStore[assetTag] = asset;
        return asset;
    }

    // POST /library/institutions — create institution
    resource function post institutions(@http:Payload Institution newInstitution)
            returns Institution|http:Conflict|http:BadRequest {

        if newInstitution.institutionId.trim() == "" {
            return <http:BadRequest>{body: "institutionId is required"};
        }

        if institutionStore.hasKey(newInstitution.institutionId) {
            return <http:Conflict>{
                body: string `Institution ${newInstitution.institutionId} already exists`
            };
        }

        institutionStore[newInstitution.institutionId] = newInstitution;
        return newInstitution;
    }

    // GET /library/institutions — list institutions
    resource function get institutions() returns Institution[] {
        return institutionStore.toArray();
    }

    // PUT /library/institutions/{institutionId} — update institution
    resource function put institutions/[string institutionId](@http:Payload Institution updated)
            returns Institution|http:NotFound {

        if !institutionStore.hasKey(institutionId) {
            return <http:NotFound>{body: string `No institution ${institutionId}`};
        }

        institutionStore[institutionId] = updated;
        return updated;
    }

    // DELETE /library/institutions/{institutionId}
    resource function delete institutions/[string institutionId]()
            returns http:Ok|http:NotFound|http:Conflict {

        if !institutionStore.hasKey(institutionId) {
            return <http:NotFound>{body: string `No institution ${institutionId}`};
        }

        Institution inst = institutionStore.get(institutionId);
        foreach Asset asset in assetStore.toArray() {
            if asset.institution == inst.name || asset.institution == inst.institutionId {
                return <http:Conflict>{
                    body: string `Cannot delete ${inst.name} — assets still reference it`
                };
            }
        }

        _ = institutionStore.remove(institutionId);
        return <http:Ok>{body: "Institution deleted"};
    }
}
