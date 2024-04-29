from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
from flask import render_template, redirect, url_for
from flask_login import login_required, current_user
import os
import sqlite3

app = Flask(__name__)
app.secret_key = '123456789'
app.config['UPLOAD_FOLDER'] = './static/images/motos/'
app.config['UPLOAD_FOLDER1'] = './static/images/tracks/'
app.config['MAX_CONTENT_LENGTH'] = 16 * 500 * 500
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

class User(UserMixin):
    def __init__(self, id, username, email, data_di_registrazione):
        self.id = id
        self.username = username
        self.email = email
        self.data_di_registrazione = data_di_registrazione

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    user = conn.execute('SELECT id, username, email, data_di_registrazione FROM utenti WHERE id = ?', (user_id,)).fetchone()
    conn.close()
    if user:
        return User(user['id'], user['username'], user['email'], user['data_di_registrazione'])
    return None


def get_db_connection():
    conn = sqlite3.connect('moto.db')
    conn.row_factory = sqlite3.Row
    return conn

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    conn = get_db_connection()
    motos = conn.execute('SELECT * FROM moto').fetchall()
    tracciati = conn.execute('SELECT * FROM tracciati').fetchall()
    conn.close()
    return render_template('index.html', motos=motos, tracciati=tracciati)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        conn = get_db_connection()
        user = conn.execute('SELECT * FROM utenti WHERE username = ?', (username,)).fetchone()
        conn.close()
        if user and check_password_hash(user['password'], password):
            user_obj = User(user['id'], user['username'], user['email'], user['data_di_registrazione'])  # Passa anche l'email e la data di registrazione
            login_user(user_obj)
            return redirect(url_for('index'))
        flash('Credenziali non valide.')
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']  # Aggiungi la raccolta dell'email dal form
        password_hash = generate_password_hash(password)
        conn = get_db_connection()
        try:
            # Modifica la query per includere la colonna email
            conn.execute('INSERT INTO utenti (username, password, email) VALUES (?, ?, ?)', (username, password_hash, email))
            conn.commit()
        except sqlite3.IntegrityError as e:
            if 'UNIQUE constraint failed: utenti.username' in str(e):
                flash('Username già in uso.')
            elif 'UNIQUE constraint failed: utenti.email' in str(e):
                flash('Email già in uso.')
            else:
                flash('Errore di registrazione.')
            return render_template('register.html')
        finally:
            conn.close()
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/add_moto', methods=('GET', 'POST'))
@login_required
def add_moto():
    if request.method == 'POST':
        modello = request.form['modello']
        cilindrata = request.form['cilindrata']
        cv = request.form['cv']
        velocita_massima =request.form['velocita_massima']
        image_file = request.files['image']
        if image_file and allowed_file(image_file.filename):
            filename = secure_filename(image_file.filename)
            image_file.save(os.path.join(app.config['UPLOAD_FOLDER'] + filename))
            print(app.config['UPLOAD_FOLDER'], filename)
            conn = get_db_connection()
            conn.execute('INSERT INTO moto (modello, cilindrata, cv, velocita_massima, image_path) VALUES (?, ?, ?, ?, ?)',
                         (modello, cilindrata, cv, int(velocita_massima), (app.config['UPLOAD_FOLDER'] + filename)[8:]))
            conn.commit()
            conn.close()
            return redirect(url_for('index'))
    return render_template('add_moto.html')

@app.route('/add_tracciato', methods=('GET', 'POST'))
@login_required
def add_tracciato():
    if request.method == 'POST':
        nome = request.form['nome']
        lunghezza = request.form['lunghezza']
        curvatura = request.form['curvatura']
        nazione = request.form['nazione']
        image_file = request.files['image']
        if image_file and allowed_file(image_file.filename):
            filename = secure_filename(image_file.filename)
            print(app.config['UPLOAD_FOLDER1'] + filename)
            image_file.save(os.path.join(app.config['UPLOAD_FOLDER1'] + filename))
            conn = get_db_connection()
            conn.execute('INSERT INTO tracciati (nome, lunghezza, curvatura, nazione, image_path) VALUES (?, ?, ?, ?, ?)',
                         (nome, float(lunghezza), int(curvatura), nazione, (app.config['UPLOAD_FOLDER1'] + filename)[8:]))
            conn.commit()
            conn.close()
            return redirect(url_for('index'))
    return render_template('add_tracciato.html')
@app.route('/profile')
@login_required
def profile():
    # Assicurati che l'utente sia loggato, grazie a `login_required`
    if not current_user.is_authenticated:
        return redirect(url_for('login'))
    # Qui passiamo l'oggetto `current_user` al template, che contiene le informazioni dell'utente loggato
    return render_template('profile.html', user=current_user)

@app.route('/commenti/<int:moto_id>', methods=['GET', 'POST'])
@login_required
def commenti(moto_id):
    conn = get_db_connection()
    # Modifica la query per includere una JOIN con la tabella utenti
    com = conn.execute(
        '''
        SELECT commenti.*, utenti.username FROM commenti
        JOIN utenti ON commenti.utente_id = utenti.id
        WHERE commenti.moto_id = ?
        ''', (moto_id, )
    ).fetchall()

    moto = conn.execute(
        '''
        SELECT * FROM moto WHERE id = ?
        ''', (moto_id, )
    ).fetchone()

    conn.close()
    
    return render_template('commenti.html', commenti_moto=com, moto=moto)


@app.route('/commenti_tracciato/<int:tracciato_id>', methods=['GET', 'POST'])
@login_required
def commenti_tracciato(tracciato_id):
    conn = get_db_connection()
    com = conn.execute(
        '''
        SELECT * FROM commenti WHERE tracciato_id = ?
        ''', (tracciato_id, )
    ).fetchall()

    tracciato = conn.execute(
        '''
        SELECT * FROM tracciati WHERE id = ?
        ''', (tracciato_id, )
    ).fetchone()
    

    conn.commit()
    conn.close()
    
    return render_template('commenti_tracciato.html', commenti_tracciato = com, tracciato = tracciato)

@app.route('/aggiungi_commento_moto/<int:moto_id>', methods=['POST'])
@login_required
def aggiungi_commento_moto(moto_id):
    testo = request.form.get('testo')
    conn = get_db_connection()
    conn.execute('INSERT INTO commenti (utente_id, moto_id, testo) VALUES (?, ?, ?)',
                 (current_user.id, moto_id, testo))
    conn.commit()
    conn.close()
    flash('Il tuo commento è stato aggiunto.')
    return redirect(url_for('commenti', moto_id=moto_id))

@app.route('/aggiungi_commento_tracciato/<int:tracciato_id>', methods=['POST'])
@login_required
def aggiungi_commento_tracciato(tracciato_id):
    testo = request.form.get('testo')
    conn = get_db_connection()
    conn.execute('INSERT INTO commenti (utente_id, tracciato_id, testo) VALUES (?, ?, ?)',
                 (current_user.id, tracciato_id, testo))
    conn.commit()
    conn.close()
    flash('Il tuo commento è stato aggiunto.')
    return redirect(url_for('commenti_tracciato', tracciato_id=tracciato_id))




if __name__ == '__main__':
    app.run(debug=True)
