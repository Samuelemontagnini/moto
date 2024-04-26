from flask import Flask, render_template, request, redirect, url_for, flash
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename
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
    def __init__(self, id, username):
        self.id = id
        self.username = username

@login_manager.user_loader
def load_user(user_id):
    conn = get_db_connection()
    user = conn.execute('SELECT * FROM utenti WHERE id = ?', (user_id,)).fetchone()
    conn.close()
    if user is None:
        return None
    return User(user['id'], user['username'])

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
            user_obj = User(user['id'], user['username'])
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
        password_hash = generate_password_hash(password)
        conn = get_db_connection()
        try:
            conn.execute('INSERT INTO utenti (username, password) VALUES (?, ?)', (username, password_hash))
            conn.commit()
        except sqlite3.IntegrityError:
            flash('Username già in uso.')
            return render_template('register.html')
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
        image_file = request.files['image']
        if image_file and allowed_file(image_file.filename):
            filename = secure_filename(image_file.filename)
            if not os.path.exists(app.config['UPLOAD_FOLDER']):
                os.makedirs(app.config['UPLOAD_FOLDER'])
            try:
                image_file.save(os.path.join(app.config['UPLOAD_FOLDER'] + filename))
                print(app.config['UPLOAD_FOLDER'], filename)
            except Exception as e:
                return f"An error occurred while saving the file: {e}"
            conn = get_db_connection()
            conn.execute('INSERT INTO moto (modello, cilindrata, cv, image_path) VALUES (?, ?, ?, ?)',
                         (modello, cilindrata, cv, filename))
            
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

if __name__ == '__main__':
    app.run(debug=True)
