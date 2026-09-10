// types.bal

public type Component record {
    string compId;
    string name;
    string description;
};

public type Schedule record {
    string scheduleId;
    string 'type; // MAINTENANCE or BOOKING
    string dueDate;
    string description;
};

public type Task record {
    string taskId;
    string description;
    boolean completed = false;
};

public type WorkOrder record {
    string orderId;
    string status;
    string description;
    Task[] tasks = [];
};

public type Asset record {
    string assetTag; // unique key for the whole system
    string name;
    string description;
    string institution;
    string site;
    string status;
    string dateAcquired;
    Component[] components = [];
    Schedule[] schedules = [];
    WorkOrder[] workOrders = [];
};

public type Institution record {
    string institutionId;
    string name;
    string[] sites = [];
};

