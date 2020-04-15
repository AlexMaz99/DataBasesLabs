package pl.edu.agh.bd.mongo;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.mongodb.*;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Projections.*;
import static com.mongodb.client.model.Sorts.*;

public class MongoLab {
	private MongoClient mongoClient;
	private MongoDatabase db;
	
	public MongoLab() throws UnknownHostException {
		mongoClient = new MongoClient();
		db = mongoClient.getDatabase("yield_academic_dataset");
	}
	
	private void showCollections(){
		for(String name : db.listCollectionNames()){
			System.out.println("colname: "+name);
		}
	}

	public long count5StarsBusinesses(){
		MongoCollection<Document> business = db.getCollection("business");
		BasicDBObject query = new BasicDBObject();
		query.put("stars", 5);
		long counter = business.countDocuments(query);
		return counter;
	}

	public void cityRestaurants(){
		MongoCollection <Document> business = db.getCollection("business");
		AggregateIterable aggResult = business.aggregate(Arrays.asList(
				Aggregates.match(Filters.eq("categories", "Restaurants")),
				Aggregates.group("$city", Accumulators.sum("count",1)),
				Aggregates.sort(Sorts.descending("count"))
		));

		for(Object result: aggResult){
			System.out.println(result);
		}
	}

	public void printStateHotelsCount(){
		MongoCollection<Document> business = db.getCollection("business");
		AggregateIterable aggResult = business.aggregate(Arrays.asList(
				Aggregates.match(Filters.and(Filters.eq("categories", "Hotels"),
						Filters.eq("attributes.Wi-Fi", "free"),
						Filters.gte("stars", 4.5)
				)),
				Aggregates.group("$state", Accumulators.sum("count", 1))
		));
		for(Object res: aggResult){
			System.out.println(res);
		}
	}

	String bestUser(){
		MongoCollection<Document> review = db.getCollection("review");
		Object userID = review.aggregate(Arrays.asList(
				Aggregates.match(Filters.gte("stars", 4.5)),
				Aggregates.group("$user_id", Accumulators.sum("count", 1)),
				Aggregates.sort(Sorts.descending("count"))
		)).first().get("_id");
		MongoCollection<Document> user = db.getCollection("user");
		return user.find(Filters.eq("user_id", userID.toString())).first().get("name").toString();
	}

	List<String> countVotes(){
		MongoCollection<Document> review = db.getCollection("review");
		List<String> votesCount = new ArrayList<>();

		long funny = review.countDocuments(Filters.gte("votes.funny", 1));
		votesCount.add("Funny: " + funny);

		long cool = review.countDocuments(Filters.gte("votes.cool", 1));
		votesCount.add("Cool: " + cool);

		long useful = review.countDocuments(Filters.gte("votes.useful", 1));
		votesCount.add("Useful:" + useful);

		System.out.println(votesCount);
		return votesCount;
	}

	public List<String> getCities(){
		return db.getCollection("business")
				.distinct("city", String.class)
				.into(new ArrayList<>());
	}

	public long getReviewsAfter2011(){
		Document query = new Document("date", new Document("$gte", "2011-01-01"));
		long result = db.getCollection("review").countDocuments(query);
		return result;
	}

	public List<Document> getClosedCompanies(){
	    return db.getCollection("business")
                    .find(eq("open", false))
                    .projection(fields(include("name", "stars", "fill_address"),
                            excludeId()))
                    .into(new ArrayList<>());
	}

	public List <Document> getUsers(){
	    return db.getCollection("user")
                .find(or(eq("votes.funny", 0), eq("votes.useful", 0)))
                .sort(ascending("name"))
                .into(new ArrayList<>());
    }

    public List<Document> getAVGStars(){
	    return db.getCollection("review").aggregate(Arrays.asList(
	            Aggregates.group("$business_id", Accumulators.avg("avgStars", "$stars")),
                Aggregates.match(Filters.gte("avgStars", 4.0))
        )).into(new ArrayList<>());
    }

    public List<Document> getTips(){
	    return db.getCollection("tip").aggregate(Arrays.asList(
	            Aggregates.group("$business_id", Accumulators.sum("count", 1))
        )).into(new ArrayList<>());
    }

    public void deleteCompaniesWithNote2(){
	    db.getCollection("business").deleteMany(eq("stars", 2.0));
    }
	public static void main(String[] args) throws UnknownHostException {
		MongoLab mongoLab = new MongoLab();
		mongoLab.showCollections();
	}


}
