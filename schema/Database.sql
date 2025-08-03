CREATE TABLE Information_Source (
    source_id      INTEGER PRIMARY KEY,
    source_name    TEXT    NOT NULL,
    source_website TEXT
);

CREATE TABLE Vaccine (
    vaccine_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    vaccine_name TEXT
);

CREATE TABLE Location (
    iso_code              TEXT    PRIMARY KEY,
    location_name         TEXT    NOT NULL,
    location_type         TEXT    NOT NULL,
    last_observation_date TEXT,
    source_id             INTEGER,
    FOREIGN KEY (
        source_id
    )
    REFERENCES Information_Source (source_id) 
);
CREATE TABLE STATE (
    state_name TEXT PRIMARY KEY,
    iso_code   TEXT,
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) 
);
CREATE TABLE Age_Group (
    age_range   TEXT,
    iso_code    TEXT,
    lower_bound INTEGER,
    upper_bound INTEGER,
    is_plus     BOOLEAN,
    PRIMARY KEY (
        age_range,
        iso_code
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code) 
);
CREATE TABLE Daily_Vaccination_Record (
    iso_code                TEXT,
    record_date             TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    daily_vaccinations      INTEGER,
    daily_people_vaccinated INTEGER,
    source_id               INTEGER,
    PRIMARY KEY (
        iso_code,
        record_date
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code),
    FOREIGN KEY (
        source_id
    )
    REFERENCES Information_Source (source_id) 
);
CREATE TABLE Vaccinetype_used_per_day (
    iso_code           TEXT,
    record_date        TEXT,
    vaccine_id         INTEGER,
    total_vaccinations INTEGER,
    PRIMARY KEY (
        iso_code,
        record_date,
        vaccine_id
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code),
    FOREIGN KEY (
        vaccine_id
    )
    REFERENCES Vaccine (vaccine_id) 
);
CREATE TABLE State_Vaccination_Record (
    state_name              TEXT,
    record_date             TEXT,
    total_vaccinations      INTEGER,
    people_vaccinated       INTEGER,
    people_fully_vaccinated INTEGER,
    total_boosters          INTEGER,
    daily_vaccination       INTEGER,
    total_distributed       INTEGER,
    PRIMARY KEY (
        state_name,
        record_date
    ),
    FOREIGN KEY (
        state_name
    )
    REFERENCES STATE (state_name) 
);
CREATE TABLE Age_Vaccination_Record (
    iso_code                            TEXT,
    age_range                           TEXT,
    record_date                         TEXT,
    people_vaccinated_per_hundred       REAL,
    people_fully_vaccinated_per_hundred REAL,
    people_with_boosters_per_hundred    REAL,
    PRIMARY KEY (
        age_range,
        iso_code,
        record_date
    ),
    FOREIGN KEY (
        age_range,
        iso_code
    )
    REFERENCES Age_Group (age_range,
    iso_code) 
);
CREATE TABLE Vaccines_in_locations (
    iso_code   TEXT,
    vaccine_id INTEGER,
    start_date TEXT,
    PRIMARY KEY (
        iso_code,
        vaccine_id
    ),
    FOREIGN KEY (
        iso_code
    )
    REFERENCES Location (iso_code),
    FOREIGN KEY (
        vaccine_id
    )
    REFERENCES Vaccine (vaccine_id) 
);

CREATE TABLE Location_Info_Source (
    iso_code TEXT ,
    source_id INTEGER ,
    PRIMARY KEY (iso_code, source_id),
    FOREIGN KEY (iso_code) REFERENCES Location(iso_code),
    FOREIGN KEY (source_id) REFERENCES Information_Source(source_id)
);