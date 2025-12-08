//
//  Quizseeder.swift
//  Hidden Library
//
//  Created by Meghan Rockwood
//
import Foundation
import FirebaseFirestore

class QuizSeeder {
    static let shared = QuizSeeder()
    private let db = Firestore.firestore()
    
    // Check if quizzes have already been seeded
    func seedQuizzesIfNeeded() {
        let seededKey = "quizzes_seeded_v2" // Changed version to force re-seed
        
        if UserDefaults.standard.bool(forKey: seededKey) {
            print("Quizzes already seeded, skipping...")
            return
        }
        
        print("🌱 Seeding pre-made quizzes...")
        seedAllGenreQuizzes()
        UserDefaults.standard.set(true, forKey: seededKey)
        print("✅ Quiz seeding complete!")
    }
    
    private func seedAllGenreQuizzes() {
        seedFantasyQuizzes()
        seedRomanceQuizzes()
        seedThrillerQuizzes()
        seedScienceFictionQuizzes()
        seedMysteryQuizzes()
        seedHistoricalQuizzes()
        seedContemporaryQuizzes()
        seedYoungAdultQuizzes()
    }
    
    // MARK: - Fantasy Quizzes
    
    private func seedFantasyQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("In 'Harry Potter', what house does Harry belong to?", ["Gryffindor", "Slytherin"], 0),
            ("Is 'The Lord of the Rings' set in Middle-earth?", ["Yes", "No"], 0),
            ("In 'The Hobbit', is Bilbo Baggins a wizard?", ["Yes", "No"], 1),
            ("Does 'The Chronicles of Narnia' feature a magical wardrobe?", ["Yes", "No"], 0),
            ("In 'A Game of Thrones', is winter coming?", ["Yes", "No"], 0),
            ("Is Gandalf a character in 'The Lord of the Rings'?", ["Yes", "No"], 0),
            ("In 'Harry Potter', does Hermione have a cat?", ["Yes", "No"], 0),
            ("Is 'The Name of the Wind' about a musician and magician?", ["Yes", "No"], 0),
            ("In fantasy literature, are dragons typically magical creatures?", ["Yes", "No"], 0),
            ("Does 'The Wheel of Time' series have multiple books?", ["Yes", "No"], 0),
            ("In 'Mistborn', is the magic system based on metals?", ["Yes", "No"], 0),
            ("Is 'The Way of Kings' the first book in the Stormlight Archive?", ["Yes", "No"], 0),
            ("In 'Percy Jackson', are the Greek gods real?", ["Yes", "No"], 0),
            ("Does 'Eragon' feature dragons?", ["Yes", "No"], 0),
            ("Is 'The Magicians' set in a magical school?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .fantasy)
    }
    
    // MARK: - Romance Quizzes
    
    private func seedRomanceQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("In 'Pride and Prejudice', does Elizabeth marry Mr. Darcy?", ["Yes", "No"], 0),
            ("Is 'The Notebook' a romance novel by Nicholas Sparks?", ["Yes", "No"], 0),
            ("In 'Outlander', does Claire travel through time?", ["Yes", "No"], 0),
            ("Is 'Me Before You' a tragic love story?", ["Yes", "No"], 0),
            ("Does 'The Fault in Our Stars' feature teenage characters?", ["Yes", "No"], 0),
            ("In 'Twilight', is Edward a vampire?", ["Yes", "No"], 0),
            ("Is 'Bridgerton' set in Regency-era England?", ["Yes", "No"], 0),
            ("Does 'Red, White & Royal Blue' feature a prince?", ["Yes", "No"], 0),
            ("In 'The Hating Game', do the main characters work together?", ["Yes", "No"], 0),
            ("Is 'Beach Read' about two writers?", ["Yes", "No"], 0),
            ("Does 'People We Meet on Vacation' span multiple years?", ["Yes", "No"], 0),
            ("In 'The Kiss Quotient', is the main character autistic?", ["Yes", "No"], 0),
            ("Is 'It Ends with Us' by Colleen Hoover?", ["Yes", "No"], 0),
            ("Does 'The Seven Husbands of Evelyn Hugo' feature a Hollywood star?", ["Yes", "No"], 0),
            ("In 'Book Lovers', is the main character a literary agent?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .romance)
    }
    
    // MARK: - Thriller Quizzes
    
    private func seedThrillerQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is 'The Girl on the Train' a psychological thriller?", ["Yes", "No"], 0),
            ("In 'Gone Girl', does Amy disappear?", ["Yes", "No"], 0),
            ("Is 'The Silent Patient' about a therapist?", ["Yes", "No"], 0),
            ("Does 'The Woman in the Window' feature an agoraphobic narrator?", ["Yes", "No"], 0),
            ("Is 'Big Little Lies' set in California?", ["Yes", "No"], 0),
            ("In 'Sharp Objects', is the main character a journalist?", ["Yes", "No"], 0),
            ("Does 'The Guest List' take place at a wedding?", ["Yes", "No"], 0),
            ("Is 'Behind Closed Doors' about a perfect couple?", ["Yes", "No"], 0),
            ("In 'Verity', is the main character a writer?", ["Yes", "No"], 0),
            ("Does 'The Last Mrs. Parrish' involve deception?", ["Yes", "No"], 0),
            ("Is 'The Couple Next Door' a domestic thriller?", ["Yes", "No"], 0),
            ("In 'Sometimes I Lie', is the narrator in a coma?", ["Yes", "No"], 0),
            ("Does 'The Perfect Marriage' feature a lawyer?", ["Yes", "No"], 0),
            ("Is 'The Hunting Party' set during a New Year's getaway?", ["Yes", "No"], 0),
            ("In 'The Turn of the Key', is the setting a smart home?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .thriller)
    }
    
    // MARK: - Science Fiction Quizzes
    
    private func seedScienceFictionQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is 'Dune' set on a desert planet?", ["Yes", "No"], 0),
            ("In '1984', is Big Brother watching?", ["Yes", "No"], 0),
            ("Does 'The Martian' take place on Mars?", ["Yes", "No"], 0),
            ("Is 'Ender's Game' about military training?", ["Yes", "No"], 0),
            ("In 'Ready Player One', is there a virtual reality world?", ["Yes", "No"], 0),
            ("Does 'The Hitchhiker's Guide to the Galaxy' feature aliens?", ["Yes", "No"], 0),
            ("Is 'Neuromancer' considered a cyberpunk novel?", ["Yes", "No"], 0),
            ("In 'Foundation', does Asimov explore psychohistory?", ["Yes", "No"], 0),
            ("Does 'Snow Crash' feature a virtual metaverse?", ["Yes", "No"], 0),
            ("Is 'The Three-Body Problem' by a Chinese author?", ["Yes", "No"], 0),
            ("In 'Brave New World', is society controlled?", ["Yes", "No"], 0),
            ("Does 'Fahrenheit 451' involve book burning?", ["Yes", "No"], 0),
            ("Is 'The Handmaid's Tale' dystopian fiction?", ["Yes", "No"], 0),
            ("In 'Starship Troopers', are there bug aliens?", ["Yes", "No"], 0),
            ("Does 'Project Hail Mary' involve space travel?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .scienceFiction)
    }
    
    // MARK: - Mystery Quizzes
    
    private func seedMysteryQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is Sherlock Holmes a famous detective?", ["Yes", "No"], 0),
            ("In 'And Then There Were None', are there ten victims?", ["Yes", "No"], 0),
            ("Does 'The Da Vinci Code' involve art history?", ["Yes", "No"], 0),
            ("Is Hercule Poirot created by Agatha Christie?", ["Yes", "No"], 0),
            ("In 'Murder on the Orient Express', does the murder happen on a train?", ["Yes", "No"], 0),
            ("Does 'The Girl with the Dragon Tattoo' feature a hacker?", ["Yes", "No"], 0),
            ("Is 'The Cuckoo's Calling' by Robert Galbraith (J.K. Rowling)?", ["Yes", "No"], 0),
            ("In 'In the Woods', is the detective named Rob?", ["Yes", "No"], 0),
            ("Does 'Big Little Lies' involve a murder?", ["Yes", "No"], 0),
            ("Is 'The Dry' set in Australia?", ["Yes", "No"], 0),
            ("In 'The Thursday Murder Club', are the detectives elderly?", ["Yes", "No"], 0),
            ("Does 'A Study in Scarlet' introduce Sherlock Holmes?", ["Yes", "No"], 0),
            ("Is 'The No. 1 Ladies' Detective Agency' set in Botswana?", ["Yes", "No"], 0),
            ("In 'The Maltese Falcon', is Sam Spade a detective?", ["Yes", "No"], 0),
            ("Does 'Gone Girl' have mystery elements?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .mystery)
    }
    
    // MARK: - Historical Quizzes
    
    private func seedHistoricalQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is 'The Book Thief' set during World War II?", ["Yes", "No"], 0),
            ("In 'All the Light We Cannot See', is the setting WWII?", ["Yes", "No"], 0),
            ("Does 'The Nightingale' take place in France?", ["Yes", "No"], 0),
            ("Is 'The Pillars of the Earth' set in medieval England?", ["Yes", "No"], 0),
            ("In 'Wolf Hall', is Thomas Cromwell the protagonist?", ["Yes", "No"], 0),
            ("Does 'The Alice Network' feature female spies?", ["Yes", "No"], 0),
            ("Is 'Outlander' partially set in 18th century Scotland?", ["Yes", "No"], 0),
            ("In 'The Help', is the setting 1960s Mississippi?", ["Yes", "No"], 0),
            ("Does 'The Tattooist of Auschwitz' take place during the Holocaust?", ["Yes", "No"], 0),
            ("Is 'Memoirs of a Geisha' set in Japan?", ["Yes", "No"], 0),
            ("In 'The Other Boleyn Girl', is Anne Boleyn featured?", ["Yes", "No"], 0),
            ("Does 'The Underground Railroad' use magical realism?", ["Yes", "No"], 0),
            ("Is 'A Gentleman in Moscow' set in a hotel?", ["Yes", "No"], 0),
            ("In 'The Invisible Woman', is the subject Charles Dickens' mistress?", ["Yes", "No"], 0),
            ("Does 'Pachinko' span multiple generations?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .historical)
    }
    
    // MARK: - Contemporary Quizzes
    
    private func seedContemporaryQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is 'Where the Crawdads Sing' a contemporary novel?", ["Yes", "No"], 0),
            ("In 'Eleanor Oliphant Is Completely Fine', is Eleanor lonely?", ["Yes", "No"], 0),
            ("Does 'The Midnight Library' explore parallel lives?", ["Yes", "No"], 0),
            ("Is 'Normal People' about two Irish students?", ["Yes", "No"], 0),
            ("In 'A Man Called Ove', is Ove grumpy?", ["Yes", "No"], 0),
            ("Does 'The Rosie Project' feature a genetics professor?", ["Yes", "No"], 0),
            ("Is 'Little Fires Everywhere' set in Ohio?", ["Yes", "No"], 0),
            ("In 'The Immortalists', do siblings learn their death dates?", ["Yes", "No"], 0),
            ("Does 'Daisy Jones & The Six' use an interview format?", ["Yes", "No"], 0),
            ("Is 'The Giver of Stars' about traveling librarians?", ["Yes", "No"], 0),
            ("In 'Such a Fun Age', does the story involve babysitting?", ["Yes", "No"], 0),
            ("Does 'The Vanishing Half' explore identity and race?", ["Yes", "No"], 0),
            ("Is 'Anxious People' about a hostage situation?", ["Yes", "No"], 0),
            ("In 'The Family Upstairs', is there a mysterious inheritance?", ["Yes", "No"], 0),
            ("Does 'The Dutch House' span decades?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .contemporary)
    }
    
    // MARK: - Young Adult Quizzes
    
    private func seedYoungAdultQuizzes() {
        let questions: [(question: String, options: [String], correct: Int)] = [
            ("Is 'The Hunger Games' about a survival competition?", ["Yes", "No"], 0),
            ("In 'Divergent', are there factions?", ["Yes", "No"], 0),
            ("Does 'The Fault in Our Stars' feature characters with cancer?", ["Yes", "No"], 0),
            ("Is 'The Maze Runner' set in a maze?", ["Yes", "No"], 0),
            ("In 'Twilight', is Bella a teenager?", ["Yes", "No"], 0),
            ("Does 'The Perks of Being a Wallflower' deal with high school?", ["Yes", "No"], 0),
            ("Is 'Looking for Alaska' by John Green?", ["Yes", "No"], 0),
            ("In 'Six of Crows', is there a heist?", ["Yes", "No"], 0),
            ("Does 'Shadow and Bone' feature the Grisha?", ["Yes", "No"], 0),
            ("Is 'The Hate U Give' about social justice?", ["Yes", "No"], 0),
            ("In 'To All the Boys I've Loved Before', are there love letters?", ["Yes", "No"], 0),
            ("Does 'Simon vs. the Homo Sapiens Agenda' deal with coming out?", ["Yes", "No"], 0),
            ("Is 'Eleanor & Park' a romance?", ["Yes", "No"], 0),
            ("In 'The 5th Wave', is there an alien invasion?", ["Yes", "No"], 0),
            ("Does 'Red Queen' feature people with silver blood?", ["Yes", "No"], 0)
        ]
        
        saveQuestions(questions: questions, genre: .youngAdult)
    }
    
    // MARK: - Save Helper with Better Logging
    
    private func saveQuestions(questions: [(question: String, options: [String], correct: Int)], genre: BookGenre) {
        print("📚 Starting to seed \(questions.count) questions for \(genre.rawValue)...")
        
        var successCount = 0
        var errorCount = 0
        
        for (index, q) in questions.enumerated() {
            let question = QuizQuestion(
                id: UUID().uuidString,
                bookId: "seeded",
                bookTitle: "Classic \(genre.rawValue) Literature",
                userId: "system",
                username: "Hidden Library",
                genre: genre,
                question: q.question,
                options: q.options,
                correctAnswer: q.correct,
                approvalVotes: 5, // Pre-approved
                isApproved: true,
                votedUserIds: [],
                createdAt: Date().addingTimeInterval(-Double(86400 * index)) // Stagger dates
            )
            
            do {
                try db.collection("quizQuestions").document(question.id).setData(from: question)
                successCount += 1
                if index == 0 {
                    print("   ✅ First question saved: \(q.question)")
                }
            } catch {
                errorCount += 1
                print("   ❌ Error seeding question \(index): \(error.localizedDescription)")
            }
        }
        
        print("   ✅ \(genre.rawValue): \(successCount) saved, \(errorCount) failed")
    }
}
