# Restaurant-App
An app to help restaurants use customer reviews to make informed decisions

## 1. User Stories (Required and Optional)

**Required Must-have Stories**

 * form for customers after they eat
 * restaurant profile
    - selected theme - types of emojis, layout, etc
    - different number of accounts per restaurant (signed into multiple devices)
    - restaurant stats
        - most popular dishes
        - least popular dishes
        - stats for each dish
        - comments on each dish
        - most and least frequently ordered dish
        - themed form chosen by restaurant 
    - restaurant profile consisting of 
        - their own menu

**Optional Nice-to-have Stories**

 * waiter reviews (waiter profiles)
 * top competitors (based on price, category and location)

## 2. Screen Archetypes

 * Login Screen/Sign up
 * Restaurant profile (editable)
 * Competitor screen (uses to Yelp API)
 * screen for waiter profile
 * Screen with restaurant stats (most popular dish, least popular dish etc.)
 * waiter profiles/stats
 * screen with form for customers to fill out


## 3. Navigation

**Tab Navigation** (Tab to Screen)

 * Restaurant Profile
 * Restaurant Data
 * Competitors

**Flow Navigation** (Screen to Screen)

 * Restaurant Profile
   * menu (editable)
   * ...
 * Restaurant Data
   * List of menu items with stats (ie. number sold, reviews etc)
   * graphical display (ie. histogram, pie charts etc)
   * summary view (shortened list view)
 * Competitors based on:
   * location
   * price
   * category/type of food
