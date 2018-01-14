# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


commedies = Category.create(name: 'TV Commedies')
dramas = Category.create(name: 'TV Dramas')

Video.create(title: 'Monk', description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", small_cover: "monk.jpg", large_cover: 'monk_large.jpg', category: commedies)
Video.create(title: 'Big Bang Theory', description: "After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.", small_cover: 'big_bang.jpg', large_cover: 'monk_large.jpg', category: dramas)
Video.create(title: 'Family guy', description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. ", small_cover: 'family_guy.jpg', large_cover: 'monk_large.jpg', category: commedies)
Video.create(title: 'South Park', description: "Fry embarks on ridiculous escapades to make sense of his predicament.", small_cover: 'south_park.jpg', large_cover: 'http://dummyimage.com/665x375/000000/00a2ff', category: commedies)
Video.create(title: 'Futurama', description: "Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. Fry embarks on ridiculous escapades to make sense of his predicament.", small_cover: 'futurama.jpg', large_cover: 'http://dummyimage.com/665x375/ffb300/00a2ff', category: dramas)
