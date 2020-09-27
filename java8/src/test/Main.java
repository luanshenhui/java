package test;

import java.util.Arrays;
import java.util.List;
import java.util.OptionalInt;

public class Main {

  public static void main(String[] args) throws Exception{
    List<Dish> menu =
        Arrays.asList( new Dish("pork", false, 800, Dish.Type.MEAT),
                       new Dish("beef", false, 700, Dish.Type.MEAT),
                       new Dish("chicken", false, 400, Dish.Type.MEAT),
                       new Dish("rice", true, 350, Dish.Type.OTHER),
                       new Dish("pizza", true, 550, Dish.Type.OTHER),
                       new Dish("prawns", false, 400, Dish.Type.FISH),
                       new Dish("salmon", false, 450, Dish.Type.FISH));
    List<Integer> numbers = Arrays.asList(3,4,5,1,2);

    Arrays.stream(numbers.toArray()).forEach(System.out::println);
    // max and OptionalInt
    OptionalInt maxCalories = menu.stream()                                                      
                                  .mapToInt(Dish::getCalories)
                                  .max();
    System.out.println("Number of calories:" + maxCalories);


  }

}

class Dish {

  private final String name;
  private final boolean vegetarian;
  private final int calories;
  private final Type type;

  public Dish(String name, boolean vegetarian, int calories, Type type) {
      this.name = name;
      this.vegetarian = vegetarian;
      this.calories = calories;
      this.type = type;
  }

  public String getName() {
      return name;
  }

  public boolean isVegetarian() {
      return vegetarian;
  }

  public int getCalories() {
      return calories;
  }

  public Type getType() {
      return type;
  }

  public enum Type { MEAT, FISH, OTHER }

  @Override
  public String toString() {
      return name;
  }


}

