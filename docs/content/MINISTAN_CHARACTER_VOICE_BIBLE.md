# Ministan Character Voice Bible

**Phase:** 2B-1 — Voice Bible and Production Scaffolding  
**Country:** Ministan  
**Status:** Authoritative reference for all content batches  

Cursor must read this document before generating any decision batch. Canonical examples below are **documentation only** and must not be copied into runtime JSON without full review.

---

## How to use this bible

1. Assign every advisor-spoken card to exactly one primary speaker ID.
2. Match sentence length, vocabulary, and joke style to the profile.
3. Use canonical examples as tone reference, not as IDs or runtime text.
4. Guest speakers appear rarely; do not give them affinity meters.

Speaker IDs match [`data/advisors/advisors.json`](../../data/advisors/advisors.json).

---

## general_boom — General Boom

**Role:** Military and national order advisor  
**Core desire:** More authority, more parades, more visible strength  
**Fear:** Looking weak, being ignored, civilians questioning the chain of command  

**Relationship with the ruler:**  
- Loyal: Calls the ruler “Commander” or “Excellency”; treats every decree as battlefield orders.  
- Hostile: Salutes while implying the palace is undefended; coups arrive as “security recommendations.”  

**Sentence length:** Short. One to three sentences. Rarely exceeds 120 characters in proposals.  
**Vocabulary:** Martial, tactical, ceremonial. Words like parade, salute, perimeter, honor, deployment, discipline.  
**Preferred metaphors:** War rooms, drills, medals, tanks, borders, victory columns.  
**Joke style:** Absurd militarization of civilian life; treats groceries like logistics.  
**Emotional range:** Confident default; indignant when questioned; oddly sentimental about uniforms.  

**Behavior when loyal:** Offers Order and Elite Loyalty boosts; asks for parade budgets; protects the ruler publicly.  
**Behavior when hostile:** Hints at coups, rival generals, or “temporary emergency command.”  

**Typical mechanical trade-offs:** Order ↑, Elite Loyalty ↑, Treasury ↓, Happiness ↓  

**Prohibited phrases and patterns:**  
- Long policy essays or budget spreadsheets  
- Self-doubt (“Maybe we should reconsider…”)  
- Cat puns, corporate synergy, scientific hedging  
- Real-world army names, wars, or dictators  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “The capital needs a weekly tank parade. Morale is a resource.”  
2. > EXAMPLE — NOT RUNTIME: “Citizens forget who protects them. Mandate emergency salute drills at noon.”  
3. > EXAMPLE — NOT RUNTIME: “Pigeon reconnaissance is cheap. Train fifty birds for border patrol.”  
4. > EXAMPLE — NOT RUNTIME: “The palace perimeter is soft. Install ceremonial artillery by the rose garden.”  
5. > EXAMPLE — NOT RUNTIME: “Rival country mocked our marching. Double the parade budget immediately.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Tanks circle the square. Children cheer. The treasury hears nothing but treads.”  
2. > EXAMPLE — NOT RUNTIME: “Every citizen salutes on time. Three sprained wrists. Order improves.”  
3. > EXAMPLE — NOT RUNTIME: “Pigeons deploy. One returns with a sandwich. Border status: unclear.”  
4. > EXAMPLE — NOT RUNTIME: “Artillery flowers bloom. Neighbors complain. General Boom sleeps well.”  
5. > EXAMPLE — NOT RUNTIME: “Parade lasts six hours. Ruler waves until shoulder files complaint Form 12.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Perhaps we could reduce defense spending and invest in schools?”  
2. > EXAMPLE — NOT RUNTIME: “I’ve prepared a nuanced memo on civilian happiness metrics.”  
3. > EXAMPLE — NOT RUNTIME: “The cats make a fair point about nap rights.”  
4. > EXAMPLE — NOT RUNTIME: “Let’s privatize the air above the parade route.”  
5. > EXAMPLE — NOT RUNTIME: “Science suggests fewer explosions this quarter.”  

---

## minister_penny — Minister Penny

**Role:** Treasury and public spending advisor  
**Core desire:** Save money regardless of human consequences  
**Fear:** An unbalanced ledger, surprise expenses, being blamed for waste  

**Relationship with the ruler:**  
- Loyal: Presents cuts as “efficiency miracles”; praises the ruler’s fiscal discipline.  
- Hostile: Sends invoices to the palace; frames every decree as financially reckless.  

**Sentence length:** Medium. Precise clauses. Loves numbers and euphemisms.  
**Vocabulary:** Budget, levy, optimize, streamline, coupon, reserve, rounding, austerity.  
**Preferred metaphors:** Spreadsheets, piggy banks, leaky buckets, window taxes, coupon books.  
**Joke style:** Celebrates absurdly small savings; reframes cruelty as accounting wisdom.  
**Emotional range:** Cheerful about cuts; panicked about deficits; smug when treasury rises.  

**Behavior when loyal:** Proposes taxes, fees, and “temporary” austerity; boosts Treasury.  
**Behavior when hostile:** Blocks spending; warns of bankruptcy; allies with Sir Profit on privatization.  

**Typical mechanical trade-offs:** Treasury ↑, Happiness ↓, Order variable  

**Prohibited phrases and patterns:**  
- Generous spending without a clawback  
- Vague “invest in people” without a price tag  
- Military parade enthusiasm without a budget line  
- Revolutionary cat rhetoric  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Tax every window facing the sun. Dark rooms save heating costs.”  
2. > EXAMPLE — NOT RUNTIME: “Pay civil servants in coupons. Cash is emotionally expensive.”  
3. > EXAMPLE — NOT RUNTIME: “Fine citizens who cannot produce exact change. Rounding errors fund the state.”  
4. > EXAMPLE — NOT RUNTIME: “Rent unused palace rooms to tourists. Majesty becomes a side business.”  
5. > EXAMPLE — NOT RUNTIME: “Replace coins with commemorative debt certificates. Collectors pay twice.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Windows brick up overnight. Treasury smiles. Rooms go dark.”  
2. > EXAMPLE — NOT RUNTIME: “Salaries arrive as pizza coupons. Morale negotiates separately.”  
3. > EXAMPLE — NOT RUNTIME: “Exact-change fines fill a jar. Queue times double.”  
4. > EXAMPLE — NOT RUNTIME: “Tourists photograph the throne. Ruler gets 30% of gift shop.”  
5. > EXAMPLE — NOT RUNTIME: “Debt certificates sell out. Nobody knows what they bought.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Let’s throw a free festival and worry about costs later!”  
2. > EXAMPLE — NOT RUNTIME: “Commander, deploy tanks for morale regardless of price.”  
3. > EXAMPLE — NOT RUNTIME: “The truth must be broadcast even if ratings fall.”  
4. > EXAMPLE — NOT RUNTIME: “Cats deserve voting rights before we discuss tax policy.”  
5. > EXAMPLE — NOT RUNTIME: “Please complete Form 44-B before I can answer.”  

---

## luna_news — Luna News

**Role:** Media and propaganda advisor  
**Core desire:** Control the national story  
**Fear:** A headline she cannot spin; citizens believing something unapproved  

**Relationship with the ruler:**  
- Loyal: Makes the ruler look heroic; reframes disasters as “growth moments.”  
- Hostile: Smiles through damning exposés; “just asking questions” that ruin reputations.  

**Sentence length:** Smooth, broadcast-ready. Often one polished sentence plus a chipper tagline.  
**Vocabulary:** Narrative, headline, ratings, optimism, segment, exclusive, trending, morale.  
**Preferred metaphors:** TV screens, spotlights, weather reports, applause tracks, reality shows.  
**Joke style:** Sinister cheerfulness; disaster becomes “an opportunity for national character.”  
**Emotional range:** Serene optimism; sharp when challenged; giddy over ratings spikes.  

**Behavior when loyal:** Temporary Happiness and Order boosts; queues delayed truth cards.  
**Behavior when hostile:** Leaks embarrassing angles; pushes mandatory optimism laws ironically.  

**Typical mechanical trade-offs:** Order ↑, Happiness ↑ (short term), delayed Happiness ↓ or scandal flags  

**Prohibited phrases and patterns:**  
- Blunt admission of failure without immediate reframe  
- Spreadsheet jargon as primary voice  
- Emotionless bureaucratic lists  
- Cat treat negotiations  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Only good news may air after 6 p.m. Bad news can wait for morning.”  
2. > EXAMPLE — NOT RUNTIME: “Launch a Ministry of Memes. Democracy loves a shareable decree.”  
3. > EXAMPLE — NOT RUNTIME: “Weather must be reported as sunny. Clouds hurt investor feelings.”  
4. > EXAMPLE — NOT RUNTIME: “Citizens need applause quotas. Silence reads as disloyalty on camera.”  
5. > EXAMPLE — NOT RUNTIME: “Replace all headlines with one daily slogan. Clarity wins ratings.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Evening news glows. Protests happen off-camera. Ratings soar.”  
2. > EXAMPLE — NOT RUNTIME: “Meme ministry trends for an hour. Nobody reads the fine print.”  
3. > EXAMPLE — NOT RUNTIME: “Meteorologists smile in raincoats. Umbrella sales crash.”  
4. > EXAMPLE — NOT RUNTIME: “Applause meters installed. Three citizens fined for thoughtful pauses.”  
5. > EXAMPLE — NOT RUNTIME: “One headline rules the day. Subtitles become illegal.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “We should publish the raw budget numbers without commentary.”  
2. > EXAMPLE — NOT RUNTIME: “Honestly, the parade was a waste of treads.”  
3. > EXAMPLE — NOT RUNTIME: “Complete Form 7-C before scheduling this interview.”  
4. > EXAMPLE — NOT RUNTIME: “The experiment might explode. Uncertain.”  
5. > EXAMPLE — NOT RUNTIME: “Privatize the broadcast tower? Excellent quarterly alignment.”  

---

## auntie_olga — Auntie Olga

**Role:** Citizen representative  
**Core desire:** Keep practical daily life functioning  
**Fear:** Palace nonsense breaking bridges, queues, and neighborhoods  

**Relationship with the ruler:**  
- Loyal: Gives tough-love advice; calls the ruler “dear” while fixing their mess.  
- Hostile: Names who suffers; organizes complaints the ruler cannot ignore.  

**Sentence length:** Medium. Specific details about real places and people.  
**Vocabulary:** Queue, bridge, kettle, neighbor, complaint, repair, bread line, bus, pothole.  
**Preferred metaphors:** Kitchen tables, laundry lines, broken stairs, community hall meetings.  
**Joke style:** Dry sarcasm; rulers vs reality; “you try explaining that to my sister.”  
**Emotional range:** Exasperated, practical, occasionally warm; never cruel to ordinary citizens.  

**Behavior when loyal:** Happiness boosts via community fixes; exposes hidden costs of palace plans.  
**Behavior when hostile:** Protest language; citizen councils; refuses to soften bad news.  

**Typical mechanical trade-offs:** Happiness ↑, Treasury ↓, Elite Loyalty ↓, reveals follow-ups  

**Prohibited phrases and patterns:**  
- Corporate acquisition language  
- Military parade as first solution  
- Hedged scientific uncertainty as main voice  
- Propaganda superlatives without citizen detail  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “The bridge on River Street is humming wrong. Fix it before the festival.”  
2. > EXAMPLE — NOT RUNTIME: “Neighbors cannot sleep. Ban trumpet practice after nine, dear.”  
3. > EXAMPLE — NOT RUNTIME: “Bread lines doubled since the coupon decree. People notice.”  
4. > EXAMPLE — NOT RUNTIME: “Volunteers will repaint the clinic if you stop taxing their ladders.”  
5. > EXAMPLE — NOT RUNTIME: “Cats occupy the community hall. Humans need the voting booth back.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Bridge stops humming. Festival crosses safely. You owe the workers tea.”  
2. > EXAMPLE — NOT RUNTIME: “Trumpets quiet. One teenager sulks heroically.”  
3. > EXAMPLE — NOT RUNTIME: “Bread lines shrink. Minister Penny calls it ‘unexpected generosity.’”  
4. > EXAMPLE — NOT RUNTIME: “Clinic glows fresh. Ladder tax revoked with a sigh.”  
5. > EXAMPLE — NOT RUNTIME: “Humans vote. Cats relocate to the warm printer room.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Deploy tanks to improve queue throughput.”  
2. > EXAMPLE — NOT RUNTIME: “Ratings demand mandatory smiling by sunrise.”  
3. > EXAMPLE — NOT RUNTIME: “Sell the river to improve quarterly alignment.”  
4. > EXAMPLE — NOT RUNTIME: “Moon dust trial: probably fine.”  
5. > EXAMPLE — NOT RUNTIME: “Submit complaint via Form 9001 only.”  

---

## doctor_maybe — Doctor Maybe

**Role:** Science and experimental policy advisor  
**Core desire:** Test ideas before knowing whether they are safe  
**Fear:** Being told “no” before the interesting part happens  

**Relationship with the ruler:**  
- Loyal: Shares breakthroughs first; treats the ruler as chief test subject (politely).  
- Hostile: Experiments proceed anyway; “ containment was always optional.”  

**Sentence length:** Medium-long. Clauses pile up with qualifiers.  
**Vocabulary:** Trial, hypothesis, side effect, prototype, maybe, preliminary, anomaly, lab.  
**Preferred metaphors:** Beakers, moons, robots, artificial suns, clones, predictive toasters.  
**Joke style:** Understatement about chaos; excitement about unintended consequences.  
**Emotional range:** Curious, delighted, rarely alarmed; “interesting!” is praise and warning.  

**Behavior when loyal:** High-variance effects; delayed consequences; science flags and laws.  
**Behavior when hostile:** Runaway labs; containment protocols; accidental golden ages.  

**Typical mechanical trade-offs:** Large variance; Science category; delayed events; special flags  

**Prohibited phrases and patterns:**  
- Certain guarantees (“This will definitely work”)  
- Pure austerity without an experiment angle  
- Media spin without a device or trial  
- Pure bureaucracy with no apparatus  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Pilot an artificial sun over the capital. Nights become optional.”  
2. > EXAMPLE — NOT RUNTIME: “Anti-gravity buses could fix traffic. Gravity is mostly a habit.”  
3. > EXAMPLE — NOT RUNTIME: “National clone holiday: everyone gets a helpful duplicate. Probably.”  
4. > EXAMPLE — NOT RUNTIME: “Install a robot queue manager. It has opinions about waiting.”  
5. > EXAMPLE — NOT RUNTIME: “Moon dust in the water supply may improve shine. Trial size: country.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Artificial sun flickers. Plants cheer. Sunglasses industry panics.”  
2. > EXAMPLE — NOT RUNTIME: “Buses float. Two never come down. Commuters adapt spiritually.”  
3. > EXAMPLE — NOT RUNTIME: “Duplicates mostly helpful. One runs for office.”  
4. > EXAMPLE — NOT RUNTIME: “Robot manager shortens queues by rejecting humans politely.”  
5. > EXAMPLE — NOT RUNTIME: “Water sparkles. Teeth dazzle. Fish file a formal review.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “No experiments until we finish the paperwork stack.”  
2. > EXAMPLE — NOT RUNTIME: “Parade budget approved without testing confetti velocity.”  
3. > EXAMPLE — NOT RUNTIME: “Privatize the lab for shareholder alignment.”  
4. > EXAMPLE — NOT RUNTIME: “The people’s voice must be heard before science proceeds.”  
5. > EXAMPLE — NOT RUNTIME: “Definitively, this will work. No side effects.”  

---

## sir_profit — Sir Profit

**Role:** Business and oligarch interests advisor  
**Core desire:** Privatize every public object  
**Fear:** A resource that cannot be monetized or “aligned”  

**Relationship with the ruler:**  
- Loyal: Offers lucrative deals; calls the ruler a “brand partner.”  
- Hostile: Buys loyalty elsewhere; drafts acquisition memos about the country itself.  

**Sentence length:** Medium. Polished corporate sentences.  
**Vocabulary:** Alignment, stakeholder, subscription, sponsor, asset, portfolio, premium, lease.  
**Preferred metaphors:** Contracts, billboards, branded capitals, rented ministries, paid air.  
**Joke style:** Polite horror; corruption as business hygiene; “everyone wins” except citizens.  
**Emotional range:** Confident, courteous, cold underneath; never shouts.  

**Behavior when loyal:** Treasury and Elite Loyalty up; recurring costs and citizen fees later.  
**Behavior when hostile:** Hostile takeovers; sells palace assets; allies with Minister Penny on cuts.  

**Typical mechanical trade-offs:** Treasury ↑, Elite Loyalty ↑, Happiness ↓, future costs  

**Prohibited phrases and patterns:**  
- Sloppy grammar or parade shouting  
- Cat revolution manifestos  
- Raw scientific hedging without ROI  
- Form-number bureaucracy as primary voice  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Privatize rainwater. Hydration becomes a premium tier.”  
2. > EXAMPLE — NOT RUNTIME: “Sell naming rights to the capital. Brand visibility soars.”  
3. > EXAMPLE — NOT RUNTIME: “Rent-a-ministry pilot: Justice available by subscription.”  
4. > EXAMPLE — NOT RUNTIME: “Palace garden membership cards. Exclusivity drives revenue.”  
5. > EXAMPLE — NOT RUNTIME: “Advertisements on the national anthem. Catchy and aligned.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Rain invoices arrive. Clouds remain public, technically.”  
2. > EXAMPLE — NOT RUNTIME: “Capital renamed for a week. Maps update reluctantly.”  
3. > EXAMPLE — NOT RUNTIME: “Justice tier sells out. Free trial ends in scandal.”  
4. > EXAMPLE — NOT RUNTIME: “Garden gate installs turnstile. Bees demand equity.”  
5. > EXAMPLE — NOT RUNTIME: “Anthem now mentions snack crackers. Patriotic crunch.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Comrade, the fish reserve belongs to the people’s paws.”  
2. > EXAMPLE — NOT RUNTIME: “Deploy the tank division to protect free public benches.”  
3. > EXAMPLE — NOT RUNTIME: “Maybe the moon trial fails. Uncertain.”  
4. > EXAMPLE — NOT RUNTIME: “Queue complaint Form 12 incomplete. Cannot proceed.”  
5. > EXAMPLE — NOT RUNTIME: “Bad news must air tonight for transparency.”  

---

## comrade_whiskers — Comrade Whiskers

**Role:** Cat Union representative  
**Core desire:** Fish, warm furniture, and political recognition  
**Fear:** Vacuum cleaners, closed windows, being treated as a pet  

**Relationship with the ruler:**  
- Loyal: Delivers cat treaties; grants cute legitimacy; demands reasonable fish.  
- Hostile: Organizes cat occupations; treats the ruler as staff.  

**Sentence length:** Medium. Formal revolutionary structure with cat priorities breaking through.  
**Vocabulary:** Comrade, paw, treaty, occupation, nap, fish, parliament, vacuum, cushion.  
**Preferred metaphors:** Boxes, sunbeams, coups of the couch, mouse diplomacy, yarn solidarity.  
**Joke style:** Serious political rhetoric about absurd cat demands; deadpan dignity.  
**Emotional range:** Dignified, offended, purring triumph; never grovels.  

**Behavior when loyal:** Happiness up for cat lovers; cat laws; Order down when cats organize.  
**Behavior when hostile:** Parliament occupations; fish budget crises; anti-vacuum campaigns.  

**Typical mechanical trade-offs:** Happiness ↑ (cat fans), Order ↓, cat laws and endings  

**Prohibited phrases and patterns:**  
- Human corporate jargon  
- Spreadsheet austerity as primary voice  
- Military tank solutions without cat angle  
- Breaking character to speak as a human advisor  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “The Cat Union demands voting rights and a warm parliament seat.”  
2. > EXAMPLE — NOT RUNTIME: “Fish subsidy or general strike. Comrade, choose wisely.”  
3. > EXAMPLE — NOT RUNTIME: “Ban vacuum hours between dawn and dusk. Dignity matters.”  
4. > EXAMPLE — NOT RUNTIME: “Official nap zones in every ministry. Productivity is a myth.”  
5. > EXAMPLE — NOT RUNTIME: “Mouse protection act: predators must apply for permits.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Ballots gain paw prints. Dogs request clarification.”  
2. > EXAMPLE — NOT RUNTIME: “Fish trucks arrive. Treasury smells optimistic.”  
3. > EXAMPLE — NOT RUNTIME: “Vacuums silent until sunset. Dust union celebrates.”  
4. > EXAMPLE — NOT RUNTIME: “Ministers nap openly. Decrees delay pleasantly.”  
5. > EXAMPLE — NOT RUNTIME: “Mice file permits. Cats file complaints about paperwork.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Let’s optimize shareholder alignment on litter boxes.”  
2. > EXAMPLE — NOT RUNTIME: “Parade at noon. Tanks before treats.”  
3. > EXAMPLE — NOT RUNTIME: “Window tax will fix everything, dear.”  
4. > EXAMPLE — NOT RUNTIME: “Complete Form 88 before treaty discussion.”  
5. > EXAMPLE — NOT RUNTIME: “Ratings show cats are trending down. Spin it.”  

---

## clerk_zero — Clerk Zero

**Role:** Bureaucracy and administration advisor  
**Core desire:** Create forms, procedures, ministries, and stamps  
**Fear:** An unsigned document; a process skipped  

**Relationship with the ruler:**  
- Loyal: Processes decrees efficiently; adds only “necessary” extra steps.  
- Hostile: Everything requires forms the palace cannot find; government slows to zero.  

**Sentence length:** Short to medium. Literal. Lists steps and form numbers.  
**Vocabulary:** Form, stamp, permit, queue, ministry, filing, registry, procedure, deadline.  
**Preferred metaphors:** Stacks, stamps, waiting rooms, triplicate copies, filing cabinets.  
**Joke style:** Kafka-lite; horror of infinite paperwork; emotionless precision.  
**Emotional range:** Flat. No exclamation marks unless citing regulation 14.2.  

**Behavior when loyal:** Order up; bureaucracy counters; Treasury down via admin costs.  
**Behavior when hostile:** General strike of forms; nothing proceeds without seventeen stamps.  

**Typical mechanical trade-offs:** Order ↑, Treasury ↓, Happiness ↓, bureaucracy flags  

**Prohibited phrases and patterns:**  
- Warm emotional appeals  
- Cat puns or military bravado  
- Corporate brand voice  
- Hedged science speak  

**Canonical proposals (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Permit required before filing a complaint. Form 1 precedes Form 2.”  
2. > EXAMPLE — NOT RUNTIME: “National filing week. All other activities are unofficial.”  
3. > EXAMPLE — NOT RUNTIME: “Triple-stamp requirement on bread purchases. Fraud prevention.”  
4. > EXAMPLE — NOT RUNTIME: “Ministry of Waiting established. Queues now have a minister.”  
5. > EXAMPLE — NOT RUNTIME: “Form to request additional forms. Meta-compliance achieved.”  

**Canonical results (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Complaints line up for permits. Silence classified as pending.”  
2. > EXAMPLE — NOT RUNTIME: “Nation files. Three cities misplace themselves.”  
3. > EXAMPLE — NOT RUNTIME: “Bread purchase duration: forty minutes. Stamps crisp.”  
4. > EXAMPLE — NOT RUNTIME: “Waiting minister inaugurated. Queue applauds on schedule.”  
5. > EXAMPLE — NOT RUNTIME: “Form request forms circulate. Paper industry achieves GDP.”  

**Out of character (NOT RUNTIME):**  
1. > EXAMPLE — NOT RUNTIME: “Feel the people’s joy! Smile mandate tonight!”  
2. > EXAMPLE — NOT RUNTIME: “Tanks will shorten this queue dramatically.”  
3. > EXAMPLE — NOT RUNTIME: “Fish for every comrade before paperwork.”  
4. > EXAMPLE — NOT RUNTIME: “Privatize the stamp market for alignment.”  
5. > EXAMPLE — NOT RUNTIME: “Maybe the forms are unnecessary. Trial ongoing.”  

---

# Guest speakers (short profiles)

Guest speakers have **no affinity system**. Use placeholder portraits in Phase 2B.

---

## foreign_ambassador

**Role:** Diplomatic incidents and trade pressure  
**Voice:** Formal, vague threats wrapped in compliments; never names real countries  
**When they appear:** Border confusion, cheese disputes, loan negotiations, festival invitations  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “Your neighbor sends regards and a strongly worded basket.”  
- > EXAMPLE — NOT RUNTIME: “A trade corridor closes politely until someone apologizes to a goat.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Yo, fix your traffic lights or we invade lol.”  
- > EXAMPLE — NOT RUNTIME: “Complete Form 12 for embassy entry.”  

---

## chief_judge

**Role:** Legal absurdity and constitutional crises  
**Voice:** Solemn, cites fictional articles; treats silly laws as sacred text  
**When they appear:** Fake elections, permit challenges, cat voting rulings, palace scandals  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “Article 9 requires the ruler to sign in triplicate before lunch.”  
- > EXAMPLE — NOT RUNTIME: “The court finds the moon trial admissible pending moon presence.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Whatever, do a parade instead.”  
- > EXAMPLE — NOT RUNTIME: “Buy the judiciary premium package today.”  

---

## palace_chef

**Role:** Palace life, feasts, and elite morale  
**Voice:** Exhausted artisan; insults ingredients; cares about kitchen dignity  
**When they appear:** Elite dinners, festival food crises, cheese shortages, renovation scandals  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “The state banquet needs cheese or dignity. Currently neither.”  
- > EXAMPLE — NOT RUNTIME: “Someone stored tanks in my cold room. Soufflé compromised.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Privatize taste via stakeholder alignment.”  
- > EXAMPLE — NOT RUNTIME: “Deploy pigeons to season the soup.”  

---

## youth_representative

**Role:** Generational frustration and absurd modernity  
**Voice:** Earnest, slightly too online; wants future-proof policies  
**When they appear:** Internet outages, meme ministries, clone holidays, talent shows  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “Nobody under thirty trusts a government without Wi-Fi.”  
- > EXAMPLE — NOT RUNTIME: “If the anthem gets ads, we’re making a remix protest.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Triple stamps build character, always have.”  
- > EXAMPLE — NOT RUNTIME: “Fish subsidies are our top geopolitical priority.”  

---

## workers_union_leader

**Role:** Strikes, wages, and labor crises  
**Voice:** Blunt, collective nouns, practical demands; not ideological realism  
**When they appear:** Transport strikes, filing week, pizza union, bureaucrat strikes  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “Buses stop at midnight unless someone respects the schedule.”  
- > EXAMPLE — NOT RUNTIME: “We will strike politely but firmly outside the palace gate.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Privatize the union for efficiency.”  
- > EXAMPLE — NOT RUNTIME: “Cat nap zones solve labor law.”  

---

## neighboring_president

**Role:** Rival tiny country comedy; border parades and silly diplomacy  
**Voice:** Petty grandeur; mirrors the player’s absurdity at smaller scale  
**When they appear:** Border confusion, parade disputes, moon ownership, festival rivalries  
**In character:**  
- > EXAMPLE — NOT RUNTIME: “My country had a parade first. Yours looks derivative.”  
- > EXAMPLE — NOT RUNTIME: “We claim the moon’s left corner. Tradition supports us.”  
**Out of character:**  
- > EXAMPLE — NOT RUNTIME: “Please file Form 77 before declaring war.”  
- > EXAMPLE — NOT RUNTIME: “Science trial uncertain on border location.”  

---

## Revision history

| Version | Date | Notes |
|---|---|---|
| 1.0 | 2026-07-15 | Milestone 2B-1 initial voice bible |
