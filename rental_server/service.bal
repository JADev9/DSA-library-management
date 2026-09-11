import ballerina/grpc;

map<Property> propertyStore = {};
map<BookingRequest> bookingStore = {};

@grpc:ServiceDescriptor {
    descriptor: PROPERTY_DESC
}
service "RentalService" on new grpc:Listener(9090) {

    remote function add_property(Property value) returns PropertyResponse {

        if propertyStore.hasKey(value.propertyId) {
            return {
                success: false,
                message: string `Property ${value.propertyId} already exists`,
                property: value
            };
        }

        propertyStore[value.propertyId] = value;

        return {
            success: true,
            message: "Property added",
            property: value
        };
    }

    remote function update_property(Property value) returns PropertyResponse {
        return {success: false, message: "not implemented", property: value};
    }

    remote function remove_property(PropertyId value) returns PropertyResponse {
        return {success: false, message: "not implemented", property: {propertyId: "", name: "", location: "", pricePerNight: 0.0, available: false}};
    }

    remote function search_property(SearchRequest value) returns PropertyResponse {
        return {success: false, message: "not implemented", property: {propertyId: "", name: "", location: "", pricePerNight: 0.0, available: false}};
    }

    remote function book_property(BookingRequest value) returns BookingResponse {
        return {success: false, message: "not implemented", totalCost: 0.0, status: "PENDING"};
    }

    remote function confirm_booking(BookingId value) returns BookingResponse {
        return {success: false, message: "not implemented", totalCost: 0.0, status: "PENDING"};
    }

    remote function create_users(stream<User, grpc:Error?> clientStream) returns UserSummary {
        return {usersCreated: 0, message: "not implemented"};
    }

    remote function list_available_properties(SearchRequest value) returns stream<Property, error?> {
        Property[] empty = [];
        return empty.toStream();
    }
}
