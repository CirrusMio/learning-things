# CirrusMio Style Guide

## Theory

* Easy to maintain code should:
  * look like it was written by a single entity
  * follow community best-practices and idioms
  * lend itself to testing, metrics gathering, and other scrutiny/verification
  * make it easy to find code dealing with a particular concern of the system
* We write code for other developers, not the interpreter.
* We have tools to help us manage and create good code.

## Practice

### See also:

* https://github.com/dkubb/styleguide/blob/master/RUBY-STYLE
* https://github.com/chneukirchen/styleguide/blob/master/RUBY-STYLE
* https://github.com/styleguide/ruby

### Filesystem Layout:

* If it encodes business logic it belongs in `app/models`, even if it isn't a
  descendent of `ActiveRecord::Base`.
* If it encodes knowledge of architecture it belongs in `lib`.
* If it extends or metaprograms existing gem/library code, it belongs in `lib`
  or in its own gem.
* Every object under test has exactly one file in `test/unit`.

*Examples*

* `app/models/ability.rb`
* `lib/test/unit/*`
* `test/unit/profile_test.rb`

### File Composition:

* Use ASCII (or UTF-8, if you have to) encoding.
* If using UTF-8, place the `# encoding: utf-8` comment at the top of the file
  (or immediately after the shebang if it is an executable).
* Use 2 space indent, no tabs.
* Use Unix-style line endings.
* Each file should have a newline as its last character.
* Files should be named after the class defined within, when appropriate.
* Files inside of modules should be inside of directories named for those
  modules.
* Keep lines fewer than 80 characters, count \n as part of that line.
* Avoid trailing whitespace on lines (.git/hooks/pre-commit can help).

### File layout:

1. Shebang, if executable
2. Encoding line, if not ASCII
3. requires of stdlib
4. requires of gems or framework source
5. requires of source from same app
6. Usage comment, if a script
7. Module and class definitions
8. Method definitions
9. Wrapped execution in `if $0 == __FILE__`, if executable
10. `__END__` and bundled data, if any

#### Examples

* *duckhunt*, an executable in a gem

~~~
    #!/usr/bin/env ruby
    # encoding: utf-8

    require 'ostruct'
    require 'gosu'
    require_relative 'lib/duckhunt/bloodhound'
    # NOTE: ostruct is STDLIB, gosu is a gem, the other is local to this library

    if  == __FILE__
      mechanics = OpenStruct.new(kb: Gosu.has_keyboard?, mouse: Gosu.has_mouse?))
      game = Duckhunt.new(mechanics)
      game.main_character = Duckhunt::Bloodhound
      game.play
    end
~~~
{: .language-ruby}

* *app/models/television.rb*, a business model in an app's library

~~~
    require 'codec/hdtv'

    # Television is responsible for playing a picture and sound stream.
    #
    # A television can get +TelevisionReception+ from many +Channels+ that
    # provide that stream.
    #
    class Television

      # A codec de-scrambles a stream into a playable representation.
      class << self
        attr_accessor :playback_codec
      end
      self.playback_codec = Codec::HDTV

      # Create a television
      def initialize start_channel
        initialize_screen
        initialize_codec
        tune_to start_channel
      end
    end
~~~
{: .language-ruby}

### Block style:

* Use `{...}` when defining blocks on one line.
* Use `do...end` for multiline blocks for side-effects, or when DSL
  authors prefer it.
* Use `{...}` for multiline blocks where the return value is relevant.

~~~
    multiples = numbers.map {|n| n * 5 }

    def select_primes
      select {|x|
        factors = factorize_in_constant_time(x)
        factors.length == 2
      }
    end

    create_task do |task|
      task.execute = 'kill -9 init'
    end
~~~
{: .language-ruby}

* Blocks are spaced out from their calling function.
* Blocks end with a space before `}` (with exceptions for making it the 79th
  character and avoiding line wrapping).

~~~
    # Yes
    new_image = pixels.map {|px| px * alpha_boost }
    irc_bot.register_callback('PING') { pong }

    # No
    new_image=pixels.map { | px |px*alpha_boost}
    irc_bot.register_callback('PING'){pong}
~~~
{: .language-ruby}

* Blocks that are called by functions that are doing assignment wrap below the
  start of their capturing/calling method, not under the assigned variable.

~~~
    # Yes
    applicable_results = my_long_named_list_of_things.select {|thing|
                           ThingSelector.new(thing).is_applicable? }

    # Maybe
    applicable_results = my_long_named_list_of_things.select {|thing|
                           ThingSelector.new(thing).is_applicable?
                         }

    # No
    applicable_results = my_long_named_list_of_things.select {|thing|
      ThingSelector.new(thing).is_applicable?  }

    # No
    applicable_results = my_long_named_list_of_things.select {|thing|
      ThingSelector.new(thing).is_applicable?
    }
~~~
{: .language-ruby}

### Flow control:

* Avoid `for` in favor of more ruby-like idioms.

~~~
    # Yes
    presidents.each {|prez| War.new(prez, Country.pick_random) }

    # No
    for prez in presidents
        War.new(prez, Country.pick_random)
    end
~~~
{: .language-ruby}

* Never use `then`, except in `case` statements where all cases are one line.

~~~
    # Yes
    case pig.fly_type
    when :none then a_ok
    when :in_a_plane then close_one
    when :with_wings then hell.feeze_over!
    else pig_doctor.check_up_on(pig)
    end

    # No
    case bird.dirtiness_with?(source_bird)
    when :only_on_weekends_when_nobody_is_home
      pull_the_curtains
    when :never then breathe_easy
    end
~~~
{: .language-ruby}

* Use `&&`/`||` for boolean expressions, `and`/`or` for control flow.
* Use `not` with words, `!` with symbols

~~~
    def handle_input string
      if ast=parse and validate(ast)
        compile ast, target: ForthMachine
      end
    end

    if pig.flying? and not hell.frozen_over?
      prepare_for_apocolypse
    else
      carry_on
    end

    self.invisible = !self.visible_to(:robots) && !self.visible_to(:aliens)
~~~
{: .language-ruby}

* Avoid multiline `?:`, use `if`.

~~~
    # Yes
    if long_object_name.long_method_name
      long_variable = assignment_from_somewhere_else
    else
      long_variable = nil
    end

    # No
    long_varaible = long_object_name.long_method_name ? \
                        assignment_from_somewhere_else : nil
~~~
{: .language-ruby}

* Align `when` and `else` with `case`.

~~~
    # YES
    case foo
    when /bar/
      raise 'baz'
    else
      print 'not bar'
    end

    # NO
    case foo
      when /bar/
        raise 'baz'
      else
        puts 'not bar'
    end
~~~
{: .language-ruby}

* When writing a check in a conditional, the tested value comes first.
* Avoid `return` when the last line is at the outermost level.
* Use explicit `return` when in a conditional.
* Use explicit `return` when short-circuiting or guarding.

~~~
    def robot_companion_type bot_attributes
      return Chumby if bot_attributes.empty?
      if bot_attributes.exists_in_future?
          return T1000
      end
      RoboCop
    end
~~~
{: .language-ruby}


### Classes:

* Classes have a leading comment like the following:

~~~
    # ClassName performs this responsibility.
    #
    # This is gramaticaly correct english with proper spelling and
    # punctuation.  The first line was *only* one line.  This paragraph
    # explains a bit more about what the class does.
    #
    # This paragraph talks about how to interface with this class.  All of
    # these lines are wrapping at 80 characters.
    #
    # = High-level Concept
    #
    # Knowledge about interoperations, architecutural impact, or specific
    # uses of this class can be placed under their own heading.
    #
    # *Give lots of examples*
    #
    #    # The 'peek' operation has an inverse of 'poke'.
    #    peek_instance = MyClass.new('peek')
    #    peek_instance.inverse #=> "poke"
    #
~~~
{: .language-ruby}

* There is no empty line between a comment and class definition.
* There should be one empty line between `def`s in a class or module.
* `private` or `public` should be isolated by a single blank line before
  and after.
* Use `private` and `public` at class scope, not for individual methods.
* Use `def self.method` to define singleton methods,
  instead of `class << self`.
* Use RDoc and its conventions for API documentation. Put an empty comment
  line between the body of the comment and the `def` except for one-line
  documentation.

~~~
    # Check for the meaning of life.
    #
    # Return true if:
    # * the attempted_answer is greater than 41
    # * the attempted_answer is less than 43
    #
    def check_for_life attempted_answer
      return attempted_answer == 42
    end

    # Life is random (and absurd), give users a number to check with.
    def get_attempt
      if guess = random(2012)
        guess += 1
      end
      guess
    end

    private

    def one
      return 1
    end

    def two
      return 2
    end

    # NO
    private :check_for_life
~~~
{: .language-ruby}

### Methods:

* Methods either express the workflow or perform a single task.
* Task-type methods should not call other task-type methods: everything
  terminates at a single, isolated, testable task method.
* There can be multiple levels of workflow methods.

~~~
    #  A good workflow method
    def  brew
      add_hot_water
      add_tea_bag
      ding_after(steep_time)
    end

    # A good task method.
    #
    # Until the resivoir reaches the target temperature (F)
    # continue adding energy (kwh).
    #
    def heat_water target=180, energy_increment=0.001
      while @resivoir.temperature < target
        @resivoir.add_energy(energy_increment)
      end
    end

    # A poor task method (does a task, then calls another task).
    def add_tea_bag brew='Earl Grey'
      box = @cubbord.get_tea_box
      bag = box.select {|tea| tea.name == brew}
      package = bag.unpackage
      dispose_of_waste(package)
      add_bag_to_cup(bag)
    end

    # Rewritten to be more appropriate as workflow.
    #
    # Interacting with other entities (cubbord, wastebasket, cup) is
    # completely encapsulated here.  The workflow can be tested by adding
    # mocks to return a double object in the case of +bag+ and the other
    # methods can be stubbed just to check they're getting the right
    # argument.
    #
    def add_teabag brew='Earl Grey'
      bag = select_tea_bag
      unpackage_and_discard_waste(bag)
      add_bag_to_cup(bag)
    end
~~~
{: .language-ruby}

* Avoid hashes-as-optional-parameters.  For task-type methods this means
  it is probably doing too much, or branching instead of performing a task.
  If you need to modify a workflow function, make a new entry-point for the
  new workflow that encodes all the knowledge instead of having it passed in.
* Avoid long parameter lists.  Don't cheat with splats or hashes.

~~~
    # No
    def process processing_object, options={}
      if options[:setup_method]
        run_setup_method(options[:setup_method])
      end
      initial_state = capture_state
      processing_object.call
      final_state = capture_state
      if options[:teardown_method]
        run_teardown_method(options[:setup_method])
      end
    end

    # Yes
    class Processor
      attr_accessor :setup_method
      attr_accessor :teardown_method

      def initialize processing_object
        @processing_object = processing_object
      end

      def process
        setup
        build_state_comparison do
          @processing_object.call
        end
        teardown
      end

      # ...
    end
~~~
{: .language-ruby}

* If sections of a method are logically separate by blank lines, then that's
  probably a sign that those sections should be split into separate methods.
* Avoid long methods.  Try to keep methods at no more than 10 lines long, and 
  preferably 5 or less.
* Code in a functional way (using small classes and only touching function
  parameters instead of global state), avoid mutation when it makes sense.
* Try to have methods either return the state of the object and have no side
  effects, or return self and have side effects. This is otherwise known as
  Command-query separation (CQS):  http://en.wikipedia.org/wiki/Command-query_separation

### General code style:

* Use single spaces around operators (`+`, `-`, `*`, etc).
* No spaces after `(`, `[` and before `]`, `)`.
* No parenthesis in method definition.
* Use ruby 1.9 hashes where you can.
* Inline conditionals (trailing conditionals) are fine when both the body and the condition fit on the same line.  If it wraps to a new line, break it into a regular `if`/`unless`-`end` block.
* Single space between hash key's `:` and the value.

~~~
    # Yes
    3 + 2
    thing.perform(param, [first, last])
    var1 = thing
    variable_two = other_thing
    {foo: 'bar'}

    # No
    3+2
    thing.perform( param, [ first, last ] )
    var1          = thing
    variable_two  = other_thing
    {foo:'bar'}
    {foo => 'bar'}
~~~
{: .language-ruby}

* Use parentheses when calling methods with arguments unless it is the only
  thing on the line, passed blocks do not count as arguments in this context.

~~~
    # Yes
    maybe_turtle = soup.ingredients(:protein)
    soup.add_ingredient turtle, :protein
    soup.prepare_ingredient(:protien) {|meat| meat.season_with(paprika) }
    soup.prepare_ingredient :protein, &meat_prep

    # No
    mabye_turtle = soup.ingredients :protien
    soup.add_ingredient(turtle, :protein)
    soup.prepare_ingredient :protein {|meat| meat.season_with(paprika) }
~~~
{: .language-ruby}

* Assignments in the first clause of conditionals are okay.  Do not put spaces around the equals sign in an assignment when it's in a condition.
* Avoid line continuation with backslash where not required.
* When breaking up a long chain over 79 characters, put `.` on the first line.
* Line up a broken method chain by moving the continuation in line with the
  first call on the top line.
* Line up a call with lots of arguments by putting arguments indented to the
  level of the first argument on the top line.  Where not possible, indent 4
  four spaces into the method being called.
* Closing `)`, `}', and ']' should not be on a line by themselves.

~~~
    # Yes
    if score = scoreboard.value(team) and score > 0
      return "#{team} scored #{score} goals"
    end

    time_limit_reached = scoreboard.game_time <= 0
    mercy_rule_invoked = scoreboard.score_difference > 10
    if time_limit_reached or mercy_rule_invoked
      game_over_man!
    end

    score.method1().method2(team).method3(time_limit_reached).
          method4().method5()

    variable_name = call_a_really_long_method_with_some_long_argument_names(
                        this_is_the_first_argument, 2)

    # No
    if scoreboard.game_time <= 0 and \
        scoreboard.score_difference > 10
      game_over_man!
    end
~~~
{: .language-ruby}

* Use `||=` freely.
* Regexp named captures are preferred.
* Use of non-OO regexps is okay, but you must set `$0...$9` to named variables
  before using them so their intent is clear.
* Use `%r` for regexp containing quotes.

~~~
    regexp = %r{[Yy]ou're an? "(?<sarcasm>\w+)" person}
    regexp =~ "You're an \\"intelligent\\" person"
    $~[:sarcasm] #=> "intelligent"
~~~
{: .language-ruby}

### Naming:

* Use snake_case for methods.
* Use CamelCase for classes and modules.
  (Keep acronyms like HTTP, RFC, XML uppercase.)
* Use SCREAMING_SNAKE_CASE for other constants.
* Single letter variable names are only okay in short blocks when assignment
  is done at the top of the block, or in calling a function that `yield`s to
  the block (like `inject`).
* Variable names should be communicative and unambiguous.
* Use consistent variable names. Try to keep the variable names close to the
  object class name.
* Use names prefixed with `_` for unused variables, for example when you
  implement a callback to an API that gives you more than you care about.
* Do not pass bare objects (strings, `true`/`false`/`nil`) into functions if
  their use is not clear.  Instead make a variable
  (called `skip_processing = true`, for example) and pass the named variable
  in instead.
* When defining binary operators, name the argument "`other`".
* Prefer `map` over `collect`, `detect` over `find`, `select` over `find_all`.

### Comments:

* Encourage discoverablility and introspection over explicit declaration.  The
  system in use should be more valuable to observe than the comments about it.
* Comments longer than a word are capitalized and use punctuation.
* Comments of a single word should probably be longer.
* Avoid superfluous comments.
* Document all consumable APIs at the module/class and method level.  In rails
  this includes everything in lib and app/models.
* Comments are a single short (must not line wrap at 80 characters)
  sentence for overview, followed by a newline, followed by exposition.
* When creating a TODO, include ownership information.
* For right now, when using static strings make a note for i18n. These
  do not have to have ownership information.
* Do not use comments or whitespace as decoration.

~~~
    # A background worker for routing unicorns to greener pastures.
    #
    # This worker is created when a `PastureChecker` process notices
    # that a pasture is overcrowded or otherwise unhelathy.  They
    # can also be created via the console for administrative tasks.
    #
    # Notice the first line of this comment was a clear sentence.  The entire
    # thing reads like two developers talking to one another.  There are
    # blank lines (still indented and containing the hash mark, but no
    # trailing space or other characters) between paragraphs.
    #
    class UnicornShuffler < BasicWorker

      # Implement the background callback.
      #
      # This directs a unicorn to fly to a new location if their old location
      # was unsuitable.  The new location is determined by the Unicorn in
      # flight, we have simply disallowed this particular location.
      def self.process unicorn, old_pasture
        flight = UnicornFlight.create(unicorn)
        # TODO: i18n
        flight.disallow_pasture old_pasture, reason: 'Not green enough'
        # TODO(todd): disallow all pastures in a 3 mile radius.
        flight.take_off!
      end
    end
~~~
{: .language-ruby}

### Testing:

* When writing an assertion for testing, the known value comes first.
* Integration tests should not look at the databse, they should observe the
  changes visible from the front-end.

### Optimization:

* Do not optimize for performance.
* Do not make use of advanced features of our infrastructure or backend
  servies.
* When optimization becomes necessary: measure, implement a fix for a single
  code path, measure in testing, release, measure.

### Misc Engineering:

* Avoid needless metaprogramming.  Avoid dependencies that encourage it.
* Avoid forking dependencies.  Write wrappers or metaprogramming patches for
  gems that don't work as expected.  Otherwise avoid the gem.
* Do not mutate arguments unless that is the purpose of the method.
* Do not mess around in core classes when writing libraries.
* Do not program defensively. (See [Erlang Style Guide](http://www.erlang.se/doc/programming_rules.shtml#HDR11)
  )
* Fail fast and loud.

### General:

* Add "global" methods to `Kernel` (if you have to) and make them private.
* Avoid `alias` when `alias_method` will do.
* Always `freeze` objects assigned to constants.
* Write for 1.9.
* Don't favor MRI over JRuby.
* Keep the code simple.
* Don't overdesign.
* Don't underdesign.
* Avoid bugs.
* Read other style guides and apply the parts that don't dissent with this
  list.  Recommended: PEP-8, PEP-257.
* Be consistent with your team and community idioms.
* Use common sense.

### Related:

* http://confreaks.com/videos/77-mwrc2009-the-building-blocks-of-modularity
* http://www.youtube.com/watch?v=npOGOmkxuio
