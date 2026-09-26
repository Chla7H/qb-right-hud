const hudStack = document.getElementById('hudStack');
const healthBar = document.getElementById('healthBar');
const armorBar = document.getElementById('armorBar');
const healthRow = document.querySelector('.health-row');
const armorRow = document.querySelector('.armor-row');
const weaponHud = document.getElementById('weaponHud');
const weaponImage = document.getElementById('weaponImage');
const weaponName = document.getElementById('weaponName');
const clipAmmo = document.getElementById('clipAmmo');
const reserveAmmo = document.getElementById('reserveAmmo');
const killBadge = document.getElementById('killBadge');
const killCount = document.getElementById('killCount');

let alwaysShowArmor = true;
let weaponVisible = false;
let killVisible = false;

const clamp = (value) => Math.max(0, Math.min(100, Number(value) || 0));

function updateBars(health, armor) {
    const safeHealth = clamp(health);
    const safeArmor = clamp(armor);

    healthBar.style.width = `${safeHealth}%`;
    armorBar.style.width = `${safeArmor}%`;

    healthRow.classList.toggle('is-critical', safeHealth > 0 && safeHealth <= 20);
    armorRow.classList.toggle('is-empty', safeArmor === 0);
    armorRow.style.display = !alwaysShowArmor && safeArmor === 0 ? 'none' : 'grid';
}

function syncWeaponHud() {
    weaponHud.classList.toggle('is-hidden', !weaponVisible && !killVisible);
    weaponHud.classList.toggle('weapon-hidden', !weaponVisible && killVisible);
    weaponHud.classList.toggle('has-kill', weaponVisible && killVisible);
    killBadge.classList.toggle('is-hidden', !killVisible);
}

function updateWeapon(data) {
    weaponVisible = data.visible === true;

    if (weaponVisible) {
        const imageKey = String(data.key || '').toLowerCase();
        const embeddedImage = window.WEAPON_IMAGES && window.WEAPON_IMAGES[imageKey];

        weaponImage.src = embeddedImage || 'icons/rifle.svg';
        weaponName.textContent = String(data.name || 'Weapon');
        clipAmmo.textContent = Math.max(0, Number(data.clip) || 0);
        reserveAmmo.textContent = Math.max(0, Number(data.reserve) || 0);
    }

    syncWeaponHud();
}

function updateKill(data) {
    killVisible = data.visible === true;
    if (killVisible) {
        killCount.textContent = `${Math.max(1, Number(data.count) || 1)}x`;
    }
    syncWeaponHud();
}


function setup(data) {
    if (typeof data.accent === 'string') {
        document.documentElement.style.setProperty('--accent', data.accent);
    }
    if (typeof data.armorColor === 'string') {
        document.documentElement.style.setProperty('--armor', data.armorColor);
    }

    document.documentElement.style.setProperty('--offset-x', `${Number(data.offsetX) || 0}px`);
    document.documentElement.style.setProperty('--offset-y', `${Number(data.offsetY) || 0}px`);
    document.documentElement.style.setProperty('--speed', `${Number(data.speed) || 220}ms`);

    alwaysShowArmor = data.alwaysShowArmor !== false;
    hudStack.classList.remove('right-center', 'right-top', 'right-bottom');
    hudStack.classList.add(['right-center', 'right-top', 'right-bottom'].includes(data.position) ? data.position : 'right-center');
}

window.addEventListener('message', (event) => {
    const data = event.data || {};

    if (data.action === 'setup') setup(data);
    if (data.action === 'update') updateBars(data.health, data.armor);
    if (data.action === 'weapon') updateWeapon(data);
    if (data.action === 'kill') updateKill(data);
    if (data.action === 'visible') hudStack.classList.toggle('is-hidden', !data.visible);
});

// Browser preview only. FiveM immediately replaces these values.
if (!window.invokeNative) {
    setup({ accent: '#ee1c3e', armorColor: '#2389ff', position: 'right-center', offsetX: 22, offsetY: 0, speed: 220 });
    updateBars(82, 58);
    updateWeapon({ visible: true, key: 'weapon_pistol_mk2', name: 'Pistol MK II', clip: 14, reserve: 232 });
    updateKill({ visible: true, count: 1 });
}
