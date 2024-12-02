/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package com.mongo.Desnormalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import org.bson.Document;

public class CrudReservas {

    String uri = "mongodb://localhost:27017";
    MongoClient mongoClient = MongoClients.create(uri);
    MongoDatabase database = mongoClient.getDatabase("parcial3");
    MongoCollection<Document> collection = database.getCollection("reservas");

    public void crearReserva(String id, Document cliente, Document habitacion, String fechaEntrada, String fechaSalida, double total, String estadoPago, String metodoPago, String fechaReserva) {
        Document reserva = new Document("_id", id)
                .append("cliente", cliente)
                .append("habitacion", habitacion)
                .append("fecha_entrada", fechaEntrada)
                .append("fecha_salida", fechaSalida)
                .append("total", total)
                .append("estado_pago", estadoPago)
                .append("metodo_pago", metodoPago)
                .append("fecha_reserva", fechaReserva);
        collection.insertOne(reserva);
        System.out.println("Reserva creada exitosamente");
    }

    public void leerReserva(String id) {
        Document reserva = collection.find(eq("_id", id)).first();
        if (reserva != null) {
            System.out.println("Reserva encontrada: " + reserva.toJson());
        } else {
            System.out.println("Reserva no encontrada");
        }
    }

    public void actualizarReserva(String id, String fecha_reserva) {
        collection.updateOne(eq("_id", id), new Document("$set", new Document("fecha_reserva", fecha_reserva)));
    }

    public void eliminarReserva(String id) {
        collection.deleteOne(eq("_id", id));
        System.out.println("Reserva eliminada exitosamente");
    }

    public void listarReservas() {
        FindIterable<Document> reservas = collection.find();
        for (Document reserva : reservas) {
            System.out.println(reserva.toJson());
        }
    }
}
