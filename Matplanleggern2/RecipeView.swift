import SwiftUI

struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let ingredients: [String]
}

struct Ingredient: Identifiable {
    let id = UUID()
    let name: String
}

struct RecipeView: View {
    let recipe: Recipe
    var ingredients: [Ingredient] {
        recipe.ingredients.map { Ingredient(name: $0) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.headline)
            List(ingredients) { ingredient in
                Text(ingredient.name)
            }
        }
    }
}

struct RecipeContentView: View {
    let recipes: [Recipe] = [
        Recipe(name: "Pancakes", ingredients: ["Flour", "Milk", "Eggs"]),
        Recipe(name: "Spaghetti Bolognese", ingredients: ["Spaghetti", "Ground Beef", "Tomato Sauce"])
    ]

    var body: some View {
        List(recipes) { recipe in
            RecipeView(recipe: recipe)
        }
    }
}
