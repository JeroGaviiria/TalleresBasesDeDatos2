package com.mongo.Normalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import org.bson.Document;

public class CrudDetallePedidos {

    String uri = "mongodb://localhost:27017";
    MongoClient mongoClient = MongoClients.create(uri);
    MongoDatabase database = mongoClient.getDatabase("parcial3");
    MongoCollection<Document> collection = database.getCollection("detalle_pedidos");

    public void crearDetallePedido(String id, String pedido_id, String producto_id, int cantidad, double precio_unitario) {
        Document detalle_pedido = new Document("_id", id)
                .append("pedido_id", pedido_id)
                .append("producto_id", producto_id)
                .append("cantidad", cantidad)
                .append("precio_unitario", precio_unitario);
        collection.insertOne(detalle_pedido);
        System.out.println("Detalle pedido insertado exitosamente");
    }

    public void leerDetallePedido(String id) {
        System.out.println("\n");
        Document detalle_pedido = collection.find(eq("_id", id)).first();
        if (detalle_pedido != null) {
            System.out.println("Detalle pedido encontrado: " + detalle_pedido.toJson());
        } else {
            System.out.println("Detalle pedido no encontrado");
        }
    }

   public void actualizarDetallePedido(String id, int cantidad) {
        collection.updateOne(eq("_id", id), new Document("$set", new Document("cantidad", cantidad)));
    }

    public void eliminarDetallePedido(String id) {
        collection.deleteOne(eq("_id", id));
        System.out.println("Producto eliminado exitosamente");
    }

    public void listarDetallePedidos() {
        System.out.println("\n");
        FindIterable<Document> detalle_pedidos = collection.find();
        for (Document detalle_pedido : detalle_pedidos) {
            System.out.println(detalle_pedido.toJson());
        }
    }
}
