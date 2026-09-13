import ballerina/grpc;
import ballerina/io;

RentalServiceClient rentalClient = check new ("http://localhost:9090");

public function main() returns error? {
    io:println("=== Rental Client Demo ===\n");

    // 1. add_property
    io:println("1. add_property");
    Property p1 = {
        propertyId: "P1",
        name: "Beach House",
        location: "Swakopmund",
        pricePerNight: 850.0,
        available: true
    };
    PropertyResponse addResp = check rentalClient->add_property(p1);
    io:println("   " + addResp.message);

    Property p2 = {
        propertyId: "P2",
        name: "Desert Lodge",
        location: "Swakopmund",
        pricePerNight: 1200.0,
        available: true
    };
    _ = check rentalClient->add_property(p2);

    // 2. list_available_properties (server streaming)
    io:println("\n2. list_available_properties (server stream)");
    SearchRequest searchReq = {location: "Swakopmund"};
    stream<Property, error?> propStream = check rentalClient->list_available_properties(searchReq);
    check propStream.forEach(function(Property p) {
        io:println("   " + p.propertyId + " | " + p.name + " | N$" + p.pricePerNight.toString());
    });

    // 3. search_property
    io:println("\n3. search_property");
    PropertyResponse searchResp = check rentalClient->search_property(searchReq);
    io:println("   " + searchResp.message + " -> " + searchResp.property.propertyId);

    // 4. update_property
    io:println("\n4. update_property");
    p1.pricePerNight = 900.0;
    PropertyResponse updateResp = check rentalClient->update_property(p1);
    io:println("   " + updateResp.message);

    // 5. book_property
    io:println("\n5. book_property");
    BookingRequest bookReq = {
        bookingId: "B1",
        propertyId: "P1",
        userId: "U1",
        startDate: "2026-10-01",
        endDate: "2026-10-05"
    };
    BookingResponse bookResp = check rentalClient->book_property(bookReq);
    io:println("   " + bookResp.message + " (status: " + bookResp.status + ")");

    // 6. confirm_booking
    io:println("\n6. confirm_booking");
    BookingId bid = {bookingId: "B1"};
    BookingResponse confirmResp = check rentalClient->confirm_booking(bid);
    io:println("   " + confirmResp.message);
    io:println("   Total cost: N$" + confirmResp.totalCost.toString());

    // 7. create_users (client streaming) — uses send()/close() pattern
    io:println("\n7. create_users (client stream)");
    User u1 = {userId: "U1", name: "Alice", role: "Guest"};
    User u2 = {userId: "U2", name: "Bob", role: "Host"};
    User u3 = {userId: "U3", name: "Carol", role: "Guest"};
    User[] users = [u1, u2, u3];

        Create_usersStreamingClient userStream = check rentalClient->create_users();
    foreach User u in users {
        check userStream->sendUser(u);
    }
    grpc:Error? completeResult = userStream->complete();
    if completeResult is grpc:Error {
        io:println("   Error completing stream: " + completeResult.message());
    } else {
        UserSummary? summary = check userStream->receiveUserSummary();
        if summary is UserSummary {
            io:println("   " + summary.message);
        }
    }

    // 8. remove_property
    io:println("\n8. remove_property");
    PropertyId pid = {propertyId: "P2"};
    PropertyResponse removeResp = check rentalClient->remove_property(pid);
    io:println("   " + removeResp.message);

    io:println("\n=== Demo complete ===");
}
