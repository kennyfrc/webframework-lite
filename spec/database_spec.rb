require_relative '../lib/database'

describe Database do
	let(:db_url) { 'postgres://localhost/frameworklite_dev' }
	
	# $1 leaves a placeholder in the sql command
	# that postgres will fill up for us
	let(:queries) do
		{
			create: %{
				create table submissions (name text, email text)
			},
			drop: %{
				drop table if exists submissions;
			},
			create_submission: %{
				insert into submissions(name, email)
				values ({name}, {email})
			},
			find_submission: %{
				select * from submissions
				where name = {name}
			}
		}
	end
	let(:db) { Database.connect(db_url, queries) }

	before do
		db.drop
		db.create
	end

	it "does not have sql injection vulnerabilities" do
		name = "'; drop table submissions; --"	
		email = "francis@askmonolith.com"
		expect { db.create_submission(name: name, email: email) }
		.to change { db.find_submission(name: name).length }
		.by(1)
	end

	it "retrieves records that it has inserted" do
		# you want to test out arguments at a different order
		# because you want the function to be scalable regardless 
		db.create_submission(name: "Francis", email: "francis@askmonolith.com")
		francis = db.find_submission(name: "Francis").fetch(0)
		expect(francis.name).to eq "Francis"
	end
	
	it "doesn't care about the order of the params" do
		# you want to test out arguments at a different order
		# because you want the function to be scalable regardless 
		db.create_submission(email: "francis@askmonolith.com", name: "Francis")
		francis = db.find_submission(name: "Francis").fetch(0)
		expect(francis.name).to eq "Francis"
	end
end
