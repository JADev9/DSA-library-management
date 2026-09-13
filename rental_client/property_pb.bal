import ballerina/grpc;
import ballerina/protobuf;

public const string PROPERTY_DESC = "0A0E70726F70657274792E70726F746F229E010A0850726F7065727479121E0A0A70726F70657274794964180120012809520A70726F7065727479496412120A046E616D6518022001280952046E616D65121A0A086C6F636174696F6E18032001280952086C6F636174696F6E12240A0D70726963655065724E69676874180420012801520D70726963655065724E69676874121C0A09617661696C61626C651805200128085209617661696C61626C65222C0A0A50726F70657274794964121E0A0A70726F70657274794964180120012809520A70726F70657274794964222B0A0D53656172636852657175657374121A0A086C6F636174696F6E18012001280952086C6F636174696F6E226D0A1050726F7065727479526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512250A0870726F706572747918032001280B32092E50726F7065727479520870726F7065727479229E010A0E426F6F6B696E6752657175657374121C0A09626F6F6B696E6749641801200128095209626F6F6B696E674964121E0A0A70726F70657274794964180220012809520A70726F7065727479496412160A067573657249641803200128095206757365724964121C0A09737461727444617465180420012809520973746172744461746512180A07656E64446174651805200128095207656E6444617465227B0A0F426F6F6B696E67526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765121C0A09746F74616C436F73741803200128015209746F74616C436F737412160A06737461747573180420012809520673746174757322290A09426F6F6B696E674964121C0A09626F6F6B696E6749641801200128095209626F6F6B696E67496422460A045573657212160A06757365724964180120012809520675736572496412120A046E616D6518022001280952046E616D6512120A04726F6C651803200128095204726F6C65224B0A0B5573657253756D6D61727912220A0C757365727343726561746564180120012805520C75736572734372656174656412180A076D65737361676518022001280952076D657373616765329D030A0D52656E74616C53657276696365122C0A0C6164645F70726F706572747912092E50726F70657274791A112E50726F7065727479526573706F6E7365122F0A0F7570646174655F70726F706572747912092E50726F70657274791A112E50726F7065727479526573706F6E736512310A0F72656D6F76655F70726F7065727479120B2E50726F706572747949641A112E50726F7065727479526573706F6E736512340A0F7365617263685F70726F7065727479120E2E536561726368526571756573741A112E50726F7065727479526573706F6E736512320A0D626F6F6B5F70726F7065727479120F2E426F6F6B696E67526571756573741A102E426F6F6B696E67526573706F6E7365122F0A0F636F6E6669726D5F626F6F6B696E67120A2E426F6F6B696E6749641A102E426F6F6B696E67526573706F6E736512250A0C6372656174655F757365727312052E557365721A0C2E5573657253756D6D617279280112380A196C6973745F617661696C61626C655F70726F70657274696573120E2E536561726368526571756573741A092E50726F70657274793001620670726F746F33";

public isolated client class RentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PROPERTY_DESC);
    }

    isolated remote function add_property(Property|ContextProperty req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/add_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function add_propertyContext(Property|ContextProperty req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/add_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function update_property(Property|ContextProperty req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/update_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function update_propertyContext(Property|ContextProperty req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        Property message;
        if req is ContextProperty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/update_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function remove_property(PropertyId|ContextPropertyId req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/remove_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function remove_propertyContext(PropertyId|ContextPropertyId req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        PropertyId message;
        if req is ContextPropertyId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/remove_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function search_property(SearchRequest|ContextSearchRequest req) returns PropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/search_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PropertyResponse>result;
    }

    isolated remote function search_propertyContext(SearchRequest|ContextSearchRequest req) returns ContextPropertyResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/search_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PropertyResponse>result, headers: respHeaders};
    }

    isolated remote function book_property(BookingRequest|ContextBookingRequest req) returns BookingResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/book_property", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingResponse>result;
    }

    isolated remote function book_propertyContext(BookingRequest|ContextBookingRequest req) returns ContextBookingResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingRequest message;
        if req is ContextBookingRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/book_property", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingResponse>result, headers: respHeaders};
    }

    isolated remote function confirm_booking(BookingId|ContextBookingId req) returns BookingResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingId message;
        if req is ContextBookingId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/confirm_booking", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <BookingResponse>result;
    }

    isolated remote function confirm_bookingContext(BookingId|ContextBookingId req) returns ContextBookingResponse|grpc:Error {
        map<string|string[]> headers = {};
        BookingId message;
        if req is ContextBookingId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("RentalService/confirm_booking", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <BookingResponse>result, headers: respHeaders};
    }

    isolated remote function create_users() returns Create_usersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("RentalService/create_users");
        return new Create_usersStreamingClient(sClient);
    }

    isolated remote function list_available_properties(SearchRequest|ContextSearchRequest req) returns stream<Property, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("RentalService/list_available_properties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return new stream<Property, grpc:Error?>(outputStream);
    }

    isolated remote function list_available_propertiesContext(SearchRequest|ContextSearchRequest req) returns ContextPropertyStream|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("RentalService/list_available_properties", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        PropertyStream outputStream = new PropertyStream(result);
        return {content: new stream<Property, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class Create_usersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveUserSummary() returns UserSummary|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <UserSummary>payload;
        }
    }

    isolated remote function receiveContextUserSummary() returns ContextUserSummary|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <UserSummary>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class PropertyStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Property value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Property value;|} nextRecord = {value: <Property>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class RentalServiceUserSummaryCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUserSummary(UserSummary response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUserSummary(ContextUserSummary response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServicePropertyResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPropertyResponse(PropertyResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPropertyResponse(ContextPropertyResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServiceBookingResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendBookingResponse(BookingResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextBookingResponse(ContextBookingResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class RentalServicePropertyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProperty(Property response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProperty(ContextProperty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertyStream record {|
    stream<Property, error?> content;
    map<string|string[]> headers;
|};

public type ContextPropertyResponse record {|
    PropertyResponse content;
    map<string|string[]> headers;
|};

public type ContextSearchRequest record {|
    SearchRequest content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextBookingRequest record {|
    BookingRequest content;
    map<string|string[]> headers;
|};

public type ContextBookingId record {|
    BookingId content;
    map<string|string[]> headers;
|};

public type ContextUserSummary record {|
    UserSummary content;
    map<string|string[]> headers;
|};

public type ContextBookingResponse record {|
    BookingResponse content;
    map<string|string[]> headers;
|};

public type ContextProperty record {|
    Property content;
    map<string|string[]> headers;
|};

public type ContextPropertyId record {|
    PropertyId content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type PropertyResponse record {|
    boolean success = false;
    string message = "";
    Property property = {};
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type SearchRequest record {|
    string location = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type User record {|
    string userId = "";
    string name = "";
    string role = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type BookingRequest record {|
    string bookingId = "";
    string propertyId = "";
    string userId = "";
    string startDate = "";
    string endDate = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type BookingId record {|
    string bookingId = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type UserSummary record {|
    int usersCreated = 0;
    string message = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type BookingResponse record {|
    boolean success = false;
    string message = "";
    float totalCost = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type Property record {|
    string propertyId = "";
    string name = "";
    string location = "";
    float pricePerNight = 0.0;
    boolean available = false;
|};

@protobuf:Descriptor {value: PROPERTY_DESC}
public type PropertyId record {|
    string propertyId = "";
|};
