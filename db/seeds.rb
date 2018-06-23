require 'random_data'

#Create Posts
50.times do
    Post.create!(
         title: RandomData.random_sentence,
         body:  RandomData.random_paragraph
    )
end

   Post.find_or_create_by!(
         title: "the week rushed by",
         body: "it's weird how I lose track of time sometimes"
)

posts = Post.all

#Create Comments
100.times do
    Comment.create!(
        post: posts.sample,
        body: RandomData.random_paragraph
    )
end

   Comment.find_or_create_by!(
       post: Post.find(id),
       body: "music makes the world go round"
)

puts "Seed finished"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
