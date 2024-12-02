package com.mongo.Desnormalizado;

import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import static com.mongodb.client.model.Aggregates.group;
import static com.mongodb.client.model.Aggregates.match;
import static com.mongodb.client.model.Filters.eq;
import static com.mongodb.client.model.Filters.gt;
import java.util.Arrays;
import org.bson.Document;

public class Reservas {
    public static void main(String[] args) {
        
        
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("parcial3");
        MongoCollection<Document> collection = database.getCollection("reservas");
        System.out.println("CONEXION EXITOSA");
        
        CrudReservas crudReservas = new CrudReservas();

        
        Document cliente = new Document("nombre", "Ana Gómez")
                .append("correo", "ana.gomez@example.com")
                .append("telefono", "+54111223344")
                .append("direccion", "Calle Ficticia 123, Buenos Aires, Argentina");

        Document habitacion = new Document("tipo", "Suite")
                .append("numero", 101)
                .append("precio_noche", 200.00)
                .append("capacidad", 2)
                .append("descripcion", "Suite con vista al mar, cama king size, baño privado y balcón.");

        // Crear reserva
        crudReservas.crearReserva(
                "reserva001", cliente, habitacion, "2024-12-15", "2024-12-18", 740, "Pagado",
                "Tarjeta de Crédito", "2024-11-30"
        );

        // Leer reserva
        crudReservas.leerReserva("reserva001");
        // Listar reservas
        crudReservas.listarReservas();
        
        // Actualizar reserva
        crudReservas.actualizarReserva("reserva001", "04-14-2024");

        // Eliminar reserva
        crudReservas.eliminarReserva("reserva001");
            
        //Obtener las habitaciones reservadas de tipo Sencilla
        FindIterable<Document> habitaciones = collection.find(eq("habitacion.tipo", "Sencilla"));
        for (Document reserva : habitaciones) {
            System.out.println(reserva.toJson());
        }
        //Obtener la sumatoria total de las reservas pagadas
        AggregateIterable<Document> resultado = collection.aggregate(Arrays.asList(
        match(eq("estado_pago", "Pagado")),
        group(null, Accumulators.sum("total_pagado", "$total"))));
        for (Document doc : resultado) {
            System.out.println("Sumatoria total de reservas pagadas: " + doc.getDouble("total_pagado"));
        }
        
        //Obtener las reservas de las habitaciones con un precio_noche mayor a 100 dolares.
        FindIterable<Document> reservas = collection.find(gt("habitacion.precio_noche", 100));
        for (Document reserva : reservas) {
            System.out.println(reserva.toJson());
        }
        
    }
}
