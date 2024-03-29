# My quotes file

## System Design Process

This list is ordered starting with greatest impact.

- Make the requirements less dumb. Attach someone with a good prespective for that requirement to each requirement. Understand each requirement.
- Delete every part you can, and flag some as non-MVP for possible future deletion. Things can be added later, do not engineer the whole world.
- Simplify every part you can. Make it match the requirement as closely and simply as possible.
- Accelerate. Get a prototype (simpler than MVP), then add something (second cycle), then continue to speed up that cycle time.
- Automate. Build the system, not the products of the system.
- Measure the results with testing, metrics, instrumentation, etc.

## System Standards

Every system should have:

- binaries
- an environment or container the binary runs in
- networking
- configs for the binaries
- encryption keys
- data used by the system
- logs produced by the binaries
- monitoring
- backups of the data, and the config/binaries/env if not asserted and recreated

## Standard Testing Concepts

I find the following test flags usually useful and often write them into my code.

- `-cover` - show me which parts of my code are covered by tests.
- `-benchmark` - run some benchmarks, measure performance gains or losses.
- `-flame` - give me flame graphs. Show me where I'm spending my time in a given test.
- `-debug` - run extra debug tests, possibly extra unit tests. When time is tight, these tests get skipped.
- `-update` - often tests produce golden output (expected output that should always be the same), this flag updates that expected output.
- `-live` - run tests against a live system. Often the live system is running alongside the tests in a second container, but mocking a system and running against the system produce different levels of accuracy.

## Slack Statuses

Let's be honest, I mostly pull my slack statuses from these files.

- "iT's eASieR sAiD ThAn DOne" buddy that's why i say things and don't do them
- This is fine. Everything is fine.
- teaching sand to think was a mistake
- mess wit teh honk u git teh bonk
- The Jira will continue until morale improves.
- i don't like sand. it's coarse, rough and irritating, and it gets everywhere
- lets try spinning thats a cool trick
- And what do we say to the God of Death? Not Today.
- Red Leader, this is Gold Leader. We're starting our attack run.
- Kubernetes is called K8s because you'll need to be training for it kindergarten thru 8th grades
- Pitter patter let's get at er
- Howdy Howdy let's get rowdy

## BOFH Quotes

- Snowflake - special system with lots of unique quirks and configuration
- Meatspace automation - paying people to do something that could be automated
- Maintenance teddy-bear: sysadmin kept on during an event who has no part of the event, but is kept online to make everyone feel better
- Weaponized ignorance: refusal to document or learn a process, instead learning/documenting the other person who knows how to fix it and just asking them every time
- Land Mine: something that comes up in postmortem but isn't documented or fixed and just hides for the next person
- Fossilized config: a config so old (often ported across systems) that it has invalid options.
- "We'll burn that bridge when we get to it"
- Percussive maintenance
- Cowboys: Sysadmin that does their own thing on their own without telling anyone, documenting, or testing
- h2ik: hell if i know
- Protoduction: prototype production, all sorts of wrong
- DevOops: accidentally bad devops
- Layer 8 problem: you figure this one out.
- Science Fair Project: some custom jank that has 0 resemblence to anything normal, usually made by a Cowboy
- Exotic pet: In a well oiled and mainted and homogonous system, the one system that works completely differently and has to be handled differently
- Golfware: something purchased by higher ups while playing golf with a vendor with no real research
- Failover: We're going to fail here, we'll fail over there, we'll use automation to fail all over the cluster.
- Fucktangular: a situation that is complicated and messy in multiple unpleasant and difficult ways
- Law of diminishing returns: If an email has 2 questions in it, the reply will come back with the answer to only one of those questions
- Law of even more diminishing returns: If an email has a single question, with two or more options offered, the reply will always be yes, with no preference offered
- Law of urgency reversal: An urgent issue that requires any small amount of work from the user, will suddenly reverse the urgency of the issue.
- Law of email relativity: An email to a manager is like a space ship attempting a sling shot round a planet. It heads to the planet, disappears for an undefined amount of time and then returns with three times the urgency that it left you.
- FFS Law: If it can go wrong, it will go wrong. At 4.55pm on a Friday.
- Law of Invisible Transference: Any test machine with Developer access eventually becomes production. Usually after it's crashed, with no backups, with no documentation.
- Rejected Solution Law: In any meeting there is a 50% chance someone suggests a solution just after it's been judged technically infeasable for >5m. This risk jumps to 80% if management is present.
- Multiplayer Server: a rooted server
