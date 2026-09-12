import ballerina/grpc;

map<Property> propertyStore = {};
map<BookingRequest> bookingStore = {};
map<BookingRequest> confirmedBookings = {};

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

        if !propertyStore.hasKey(value.propertyId) {
            return {
                success: false,
                message: string `Property ${value.propertyId} not found`,
                property: value
            };
        }

        propertyStore[value.propertyId] = value;

        return {
            success: true,
            message: "Property updated",
            property: value
        };
    }    


        remote function remove_property(PropertyId value) returns PropertyResponse {

        if !propertyStore.hasKey(value.propertyId) {
            return {
                success: false,
                message: string `Property ${value.propertyId} not found`,
                property: {propertyId: "", name: "", location: "", pricePerNight: 0.0, available: false}
            };
        }

        Property removed = propertyStore.get(value.propertyId);
        _ = propertyStore.remove(value.propertyId);

        return {
            success: true,
            message: string `Property ${value.propertyId} removed`,
            property: removed
        };
    }

        remote function search_property(SearchRequest value) returns PropertyResponse {

        foreach Property p in propertyStore {
            if p.location == value.location && p.available {
                return {
                    success: true,
                    message: "Available",
                    property: p
                };
            }
        }

        return {
            success: false,
            message: "Not Available",
            property: {propertyId: "", name: "", location: "", pricePerNight: 0.0, available: false}
        };
    }

        remote function book_property(BookingRequest value) returns BookingResponse {

        if !propertyStore.hasKey(value.propertyId) {
            return {
                success: false,
                message: string `Property ${value.propertyId} not found`,
                totalCost: 0.0,
                status: "REJECTED"
            };
        }

        if value.endDate <= value.startDate {
            return {
                success: false,
                message: "End date must be after start date",
                totalCost: 0.0,
                status: "REJECTED"
            };
        }

        bookingStore[value.bookingId] = value;

        return {
            success: true,
            message: "Added to booking cart",
            totalCost: 0.0,
            status: "PENDING"
        };
    }

        remote function confirm_booking(BookingId value) returns BookingResponse {

        if !bookingStore.hasKey(value.bookingId) {
            return {
                success: false,
                message: "No pending booking with that ID",
                totalCost: 0.0,
                status: "REJECTED"
            };
        }

        BookingRequest req = bookingStore.get(value.bookingId);

        if !propertyStore.hasKey(req.propertyId) {
            return {
                success: false,
                message: "Property no longer exists",
                totalCost: 0.0,
                status: "REJECTED"
            };
        }

        foreach BookingRequest b in confirmedBookings {
            if b.propertyId == req.propertyId {
                if !(req.endDate <= b.startDate || req.startDate >= b.endDate) {
                    return {
                        success: false,
                        message: "Dates overlap with existing booking",
                        totalCost: 0.0,
                        status: "REJECTED"
                    };
                }
            }
        }

        Property prop = propertyStore.get(req.propertyId);
        int nights = daysBetween(req.startDate, req.endDate);
        float cost = prop.pricePerNight * <float>nights;

        confirmedBookings[req.bookingId] = req;
        _ = bookingStore.remove(req.bookingId);

        return {
            success: true,
            message: string `Booking confirmed for ${nights} night(s)`,
            totalCost: cost,
            status: "CONFIRMED"
        };
    }

    remote function create_users(stream<User, grpc:Error?> clientStream) returns UserSummary {
        return {usersCreated: 0, message: "not implemented"};
    }

    remote function list_available_properties(SearchRequest value) returns stream<Property, error?> {
        Property[] empty = [];
        return empty.toStream();
    }
}

function daysBetween(string startDate, string endDate) returns int {
    int sy = checkpanic int:fromString(startDate.substring(0, 4));
    int sm = checkpanic int:fromString(startDate.substring(5, 7));
    int sd = checkpanic int:fromString(startDate.substring(8, 10));
    int ey = checkpanic int:fromString(endDate.substring(0, 4));
    int em = checkpanic int:fromString(endDate.substring(5, 7));
    int ed = checkpanic int:fromString(endDate.substring(8, 10));
    return (ey - sy) * 365 + (em - sm) * 30 + (ed - sd);
}
