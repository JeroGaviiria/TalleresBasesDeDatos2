package com.mongo.Normalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import org.bson.Document;

public class CrudPedidos {

    String uri = "mongodb://localhost:27017";
    MongoClient mongoClient = MongoClients.create(uri);
    MongoDatabase database = mongoClient.getDatabase("parcial3");
    MongoCollection<Document> collection = database.getCollection("pedidos");

    public void crearPedido(String id, String cliente, String fecha_pedido, String estado, double total) {
        Document pedido = new Document("_id", id)
                .append("cliente", cliente)
                .append("fecha_pedido", fecha_pedido)
                .append("estado", estado)
                .append("total", total);
        collection.insertOne(pedido);
        System.out.println("Pedido agendado exitosamente");
    }

    public void leerPedido(String id) {
        System.out.println("\n");
        Document pedido = collection.find(eq("_id", id)).first();
        if (pedido != null) {
            System.out.println("Pedido encontrado: " + pedido.toJson());
        } else {
            System.out.println("Pedido no encontrado");
        }
    }

   public void actualizarPedido(String id, String fecha_pedido) {
        collection.updateOne(eq("_id", id), new Document("$set", new Document("fecha_pedido", fecha_pedido)));
    }

    public void eliminarPedido(String id) {
        collection.deleteOne(eq("_id", id));
        System.out.println("Pedido eliminado exitosamente");
    }

    public void listarPedidos() {
        System.out.println("\n");
        FindIterable<Document> pedidos = collection.find();
        for (Document pedido : pedidos) {
            System.out.println(pedido.toJson());
        }
    }
}
