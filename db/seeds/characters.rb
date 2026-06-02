module Seeds
  module Characters
    module_function

    def call(context)
      bobba_fett = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:kamino),
        name: 'Bobba Fett',
        attributes: {
          occupation: 'Bounty hunter',
          description: 'An unaltered clone of Jango Fett who became one of the galaxy\'s most feared bounty hunters and later a power on Tatooine.'
        }
      )
      Helpers.attach_seed_image(bobba_fett, :portrait_image, 'portraits', 'star wars', 'bobba.png')

      ahsoka_tano = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:coruscant),
        name: 'Ahsoka Tano',
        attributes: {
          occupation: 'Former Jedi Padawan',
          description: 'Anakin Skywalker\'s former Padawan, a Clone Wars commander, and a Force-user who continued fighting tyranny after leaving the Jedi Order.'
        }
      )
      Helpers.attach_seed_image(ahsoka_tano, :portrait_image, 'portraits', 'star wars', 'ahsoka.jpg')

      padme_amidala = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:coruscant),
        name: 'Padme Amidala',
        attributes: {
          occupation: 'Senator',
          description: 'Former Queen of Naboo and later senator, Padme was a principled Republic leader and secret wife of Anakin Skywalker.'
        }
      )

      darth_vader = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:coruscant),
        name: 'Darth Vader',
        attributes: {
          occupation: 'Sith Lord',
          description: 'Once Anakin Skywalker, Darth Vader became the armored Sith enforcer of the Galactic Empire.'
        }
      )

      luke_skywalker = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:tatooine),
        name: 'Luke Skywalker',
        attributes: {
          occupation: 'Jedi Knight',
          description: 'A farm boy from Tatooine who joined the Rebel Alliance, destroyed the Death Star, and became a Jedi.'
        }
      )

      leia_organa = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:yavin_iv),
        name: 'Leia Organa',
        attributes: {
          occupation: 'Rebel leader',
          description: 'Princess of Alderaan, leader in the Rebel Alliance, daughter of Padme Amidala and Anakin Skywalker, and twin sister of Luke Skywalker.'
        }
      )

      darth_maul = Helpers.upsert_character(
        universe: context.fetch(:star_wars),
        world: context.fetch(:mandalore),
        name: 'Darth Maul',
        attributes: {
          occupation: 'Sith apprentice',
          description: 'A Dathomirian warrior trained by Darth Sidious who survived defeat and later built a criminal power base.'
        }
      )

      eddard_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Eddard Stark',
        attributes: {
          nickname: 'Ned',
          occupation: 'Lord of Winterfell',
          description: 'Patriarch of House Stark and Warden of the North.'
        }
      )

      catelyn_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Catelyn Stark',
        attributes: {
          occupation: 'Lady of Winterfell',
          description: 'Born Catelyn Tully of Riverrun, she married Eddard Stark and became mother to the Stark children of Winterfell.'
        }
      )

      jon_snow = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Jon Snow',
        attributes: {
          occupation: 'Night\'s Watch steward',
          description: 'Raised at Winterfell as Eddard Stark\'s acknowledged bastard son, Jon joins the Night\'s Watch while his true parentage remains hidden in the books.'
        }
      )

      robb_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Robb Stark',
        attributes: {
          occupation: 'Heir to Winterfell',
          description: 'Eddard and Catelyn Stark\'s eldest trueborn son, later proclaimed King in the North by his bannermen.'
        }
      )

      sansa_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Sansa Stark',
        attributes: {
          occupation: 'Lady of Winterfell',
          description: 'Eddard and Catelyn Stark\'s eldest daughter, raised for courtly life before the War of the Five Kings changes her path.'
        }
      )

      arya_stark = Helpers.upsert_character(
        universe: context.fetch(:ice_and_fire),
        world: context.fetch(:planetos),
        name: 'Arya Stark',
        attributes: {
          occupation: 'Noblewoman',
          description: 'Eddard and Catelyn Stark\'s younger daughter, independent and restless, with a talent for swordplay and survival.'
        }
      )

      jarl_balgruuf = Helpers.upsert_character(
        universe: context.fetch(:elder_scrolls),
        world: context.fetch(:nirn),
        name: 'Jarl Balgruuf',
        attributes: {
          full_name: 'Balgruuf the Greater',
          occupation: 'Jarl of Whiterun',
          description: 'The Jarl of Whiterun during Skyrim\'s civil war, Balgruuf is a pragmatic Nord ruler who tries to protect his hold amid dragon attacks and political pressure.'
        }
      )

      punisher = Helpers.upsert_character(
        universe: context.fetch(:marvel),
        world: nil,
        name: 'Punisher',
        attributes: {
          full_name: 'Frank Castle',
          occupation: 'Vigilante',
          description: 'A former Marine whose family was murdered, Frank Castle wages a brutal one-man war on organized crime.'
        }
      )

      daredevil = Helpers.upsert_character(
        universe: context.fetch(:marvel),
        world: nil,
        name: 'Daredevil',
        attributes: {
          full_name: 'Matt Murdock',
          occupation: 'Attorney and vigilante',
          description: 'Blinded as a child, Matt Murdock uses heightened senses and martial training to defend Hell\'s Kitchen as Daredevil.'
        }
      )

      black_widow = Helpers.upsert_character(
        universe: context.fetch(:marvel),
        world: nil,
        name: 'Black Widow',
        attributes: {
          full_name: 'Natasha Romanoff',
          occupation: 'Spy and assassin',
          description: 'Natasha Romanoff is a master spy and former assassin who became one of the Avengers\' most capable operatives.'
        }
      )

      batman = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Batman',
        attributes: {
          full_name: 'Bruce Wayne',
          occupation: 'Vigilante',
          description: 'Bruce Wayne protects Gotham City as Batman, relying on detective work, training, technology, and an uncompromising war on crime.'
        }
      )

      static_shock = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Static Shock',
        attributes: {
          full_name: 'Virgil Hawkins',
          occupation: 'Teen superhero',
          description: 'Virgil Hawkins becomes the electromagnetic hero Static, balancing school, family, and protecting Dakota.'
        }
      )

      catwoman = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Catwoman',
        attributes: {
          full_name: 'Selina Kyle',
          occupation: 'Cat burglar',
          description: 'Selina Kyle is Gotham\'s infamous cat burglar, moving between self-interest, heroism, and a complicated bond with Batman.'
        }
      )

      leonardo = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Leonardo',
        attributes: {
          occupation: 'Ninja',
          description: 'The disciplined blue-masked Teenage Mutant Ninja Turtle, often acting as field leader of his brothers.'
        }
      )

      raphael = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Raphael',
        attributes: {
          occupation: 'Ninja',
          description: 'The red-masked Teenage Mutant Ninja Turtle, known for intensity, toughness, and a rebellious streak.'
        }
      )

      donatello = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Donatello',
        attributes: {
          occupation: 'Ninja and inventor',
          description: 'The purple-masked Teenage Mutant Ninja Turtle, the team\'s inventive technologist and strategist.'
        }
      )

      michelangelo = Helpers.upsert_character(
        universe: context.fetch(:dc),
        world: nil,
        name: 'Michelangelo',
        attributes: {
          occupation: 'Ninja',
          description: 'The orange-masked Teenage Mutant Ninja Turtle, cheerful, impulsive, pizza-loving, and deeply loyal to his brothers.'
        }
      )

      {
        bobba_fett: bobba_fett,
        ahsoka_tano: ahsoka_tano,
        padme_amidala: padme_amidala,
        darth_vader: darth_vader,
        luke_skywalker: luke_skywalker,
        leia_organa: leia_organa,
        darth_maul: darth_maul,
        eddard_stark: eddard_stark,
        catelyn_stark: catelyn_stark,
        jon_snow: jon_snow,
        robb_stark: robb_stark,
        sansa_stark: sansa_stark,
        arya_stark: arya_stark,
        jarl_balgruuf: jarl_balgruuf,
        punisher: punisher,
        daredevil: daredevil,
        black_widow: black_widow,
        batman: batman,
        static_shock: static_shock,
        catwoman: catwoman,
        leonardo: leonardo,
        raphael: raphael,
        donatello: donatello,
        michelangelo: michelangelo
      }
    end
  end
end
