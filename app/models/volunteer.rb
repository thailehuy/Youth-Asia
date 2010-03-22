class Volunteer < ActiveRecord::Base
  POSITION = [
    "Position 1",
    "Position 2",
    "Position 3",
  ]

  SCHOOLS = [
    "Asia Pacific Institute of Information Technology (APIIT)",
    "HELP University College",
    "International Islamic University Malaysia (IIUM)",
    "INTI University College Subang",
    "KBU University College (KBU)",
    "KDU Damansara Utama",
    "Kolej Universiti Teknologi dan Pengurusan Malaysia (KUTPM)",
    "Lim Kok Wing Institute of Communications Technology (LICT)",
    "Malaysia University Of Science and Technology (MUST)",
    "Management and Science University (MSU)",
    "Metropolitan College",
    "Monash University Sunway",
    "Multimedia University (MMU) - Cyberjaya",
    "SEGi College - Kota Damansara",
    "Sunway University College",
    "TAR College, Setapak",
    "Taylor's College of Hospitality & Tourism",
    "Taylor's University College",
    "Universiti Kebangsaan Malaysia (UKM)",
    "Universiti Malaysia Pahang (UMP)",
    "Universiti Malaysia Perlis (UniMAP)",
    "Universiti Malaysia Sabah (UMS)",
    "Universiti Malaysia Terengganu (UMT)",
    "Universiti Putra Malaysia (UPM)",
    "Universiti Sains Islam Malaysia (USIM)",
    "Universiti Teknikal Malaysia (UTeM)",
    "Universiti Tenaga Nasional (UNITEN)",
    "Universiti Tun Hussein Onn Malaysia (UTHM)",
    "Universiti Tunku Abdul Rahman (UTAR) - Petaling Jaya",
    "University College Sedaya International (UCSI)",
    "University Malaysia Sarawak (UNIMAS)",
    "University of Malaya (UM)",
    "University of Nottingham Malaysia Campus",
    "University Pendidikan Sultan Idris (UPS)",
    "University Sains Malaysia (USM)",
    "University Teknologi Malaysia (UTM)",
    "University Teknologi Mara - Alor Gajah, Melaka",
    "University Teknologi Mara - Alor Gajah, Negeri Sembilan",
    "University Teknologi Mara - Arau, Perlis",
    "University Teknologi Mara - Dungun, Terengganu",
    "University Teknologi Mara - Jengka, Pahang",
    "University Teknologi Mara - Kota Kinabalu, Sabah",
    "University Teknologi Mara - Kota Samarahan, Sarawak",
    "University Teknologi Mara - Machang, Kelantan",
    "University Teknologi Mara - Permatang Pauh, Pulau Pinang",
    "University Teknologi Mara - Shah Alam, Selangor",
    "University Teknologi Mara - Skudai, Johor",
    "University Teknologi Mara - Sri Iskandar, Perak",
    "University Teknologi Mara - Sungai Petani, Kedah",
    "University Utara Malaysia (UUM)"
  ]

  STATES = [
    "Johor",
    "Kedah",
    "Kelantan",
    "Kuala Lumpur",
    "Labuan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Perak",
    "Perlis",
    "Pulau Pinang",
    "Putrajaya",
    "Sabah",
    "Selangor",
    "Sarawak",
    "Terengganu"
  ]

  has_attachment :max_size => 500.kilobytes

  validates_as_attachment

  validates_inclusion_of :school, :in => SCHOOLS
  validates_inclusion_of :state, :in => STATES

  validates_presence_of :name, :message => "Please enter your name"
  validates_presence_of :email, :message => "Please enter your email"
  validates_presence_of :ic_number, :message => "Please enter your IC number"
  validates_presence_of :position_1, :message => "Please choose your first preferred position"
  validates_presence_of :reason, :message => "Please tell us why you want to volunteer"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
end
