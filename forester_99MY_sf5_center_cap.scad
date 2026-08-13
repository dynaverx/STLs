// ############################################################################
// # CENTER CAP - TAM PARAMETRIK  
// # parametrik snap-fit tirnaklar. Mesh bagimliligi yok.
// # Snap tirnak: smooth GIRIS rampasi + BEL (esneme boynu) + BARB/YAKALAMA.
// ############################################################################

use <subaru_wordmark.scad>   // gercek Subaru harf konturlari (poligon, mesh degil)
// ############################################################################
// # SUBARU WORDMARK - 2D KONTUR (parametrik; MESH IMPORT YOK)
// #
// # Kaynak: Thingiverse thing:5194974 - BritneyDesigns, CC-BY.
// # Konturlar o STL'lerden z=8.0 duzleminde dilimlenip zincirlendi.
// # NEDEN z=8: parcanin alt yarisinda harfleri birbirine baglayan ince bir
// # KOPRU ve 4 adet 6.3 mm (0.25") montaj DELIGI var. z>7'de ikisi de biter,
// # geriye tam 6 harf + 4 ic bosluk kalir. Orta duzlemden dilimleseydin
// # harfler birbirine yapisik cikar, uzerlerinde delikler olurdu.
// # yapamayanlar olursa bu wordmarkı (thingverse linkinden mesh çıkart) ulaşabilirler.


/* [Disk / kubbe -, rotate_extrude ile uretilir] */
kapak_cy    = 30.71;   // disk merkezi Y  (eksen = X)   [tirnak yerlesimi icin]
kapak_cz    = 30.70;   // disk merkezi Z
disk_cap    = 61.40;   // *** dis cap [mm] ***
disk_arka_x = 5.00;    // arka yuz X (tirnak tabani duzlemi)
disk_kenar_x= 6.60;    // kubbenin KENARDAKI yuksekligi X
disk_tepe_x = 8.25;    // kubbe TEPE (merkez) X
disk_ici_bosalt = false; // arkadan kubbe cebi ac (malzeme azalt)
disk_cidar   = 2.0;    // bosaltinca cidar kalinligi [mm]
disk_dis_r  = disk_cap/2;   // dis yaricap (barb bunu asmasin)

/* [YENI SNAP-FIT TIRNAK - ana parametreler] */
tab_sayisi        = 8;      // tirnak sayisi   (6 -> 8: yuk dagilir, her tirnak az esner)
tab_oturma_capi   = 57.0;    // *** BARB'IN OTURDUGU CAP [mm] (kavrama capi) ***
tab_teget         = 10.0;     // tegetsel genislik [mm]
tab_aci0          = 7;       // ilk tirnak acisi [deg]
tab_taban_x       = 5.2;     // taban govdeye baglanti X'i

/* [Snap profil - kesit sekli (buyume buradan)] */
tab_boy           = 10.0;     // eksenel boy / cikinti L [mm]  (12.5 -> 10: kisa kol = rijit)
taban_kalinlik    = 1.6;     // taban radyal kalinlik [mm]  (1.0 -> 1.6, asagidaki nota bak)
bel_kalinlik      = 2.6;     // BEL (waist) kalinlik [mm]  (2.0 -> 2.6: ana sertlestirme)
barb_cikinti      = 1.2;     // barb'in tabandan disari cikmasi [mm] (kavrama)
barb_tepe         = 0.6;     // barb duz tepe uzunlugu [mm] (keskin uc olmasin)
uc_kalinlik       = 0.9;     // uc kalinlik [mm]
giris_rampa       = 3.2;     // smooth GIRIS rampasi uzunlugu [mm] (lead-in)
yakalama_boyu     = 0.7;     // YAKALAMA yuzu uzunlugu [mm] (kisa = dik tutma)
taban_uzunluk     = 1.6;     // taban bolgesi eksenel uzunluk [mm]
bel_baslangic     = 2.6;     // bel baslangic eksenel konum [mm]
tab_gomme         = 1.2;     // tabanin govde icine gomulme payi [mm]
tab_yuvarlat      = 0.4;     // kenar yuvarlatma (0 = keskin)

// ### NEDEN taban_kalinlik DA BUYUDU ###
// Barb tepesi qg = taban_kalinlik + barb_cikinti. Profilin gecerli olmasi icin
// taban_kalinlik < bel_kalinlik < qg olmali - yani bel, barb tepesinden INCE
// kalmali, yoksa barb cikintisi kaybolur ve tirnak hic kavramaz.
// Eski: 1.0 < 2.0 < 2.2  (pay sadece 0.2)
// Yeni: 1.6 < 2.6 < 2.8  (ayni 0.2 pay, ama her sey kalin)
// barb_cikinti'ye DOKUNULMADI (1.2): kavrama ayni, takma esnemesi artmadi.
// tab_oturma_capi barb TEPESINE gore olculdugu icin gecme capi da degismedi.

/* [Taban guclendirme - KOK gusset; her yon AYRI, 0 = o yone cizme] */
// Tab RADYAL buruluyor (barb ic/dis). Bukulme gerilmesi kokte, DIS (barb) yuzde.
// UYARI: guc_boy, bel_baslangic'ten KUCUK olmali; yoksa bel'i (esneme boynunu)
//        kalinlastirip tirnagi kilitler.
taban_guc_aktif   = true;
guc_boy           = 2.2;     // kokten yukselme uzunlugu [mm] (< bel_baslangic!)
guc_radyal_dis    = 2.0;     // DIS (barb / gerilme) yone rampa [mm]   (1.4 -> 2.0)
guc_radyal_ic     = 0.0;     // IC (merkez) yone rampa [mm]            (0 = yok)
guc_teget         = 0.0;     // tegetsel her yana [mm]                 (0 = yok)

/* [GOMME YAZI - GERCEK SUBARU WORDMARK] */
// Artik sistem fontu (Futura vb.) DEGIL: harf konturlari Subaru'nun kendi
// wordmark cizimlerinden cikarildi. Kaynak Thingiverse thing:5194974
// (BritneyDesigns, CC-BY) STL'leri; konturlar dilimlenip poligona cevrildi.
// subaru_wordmark.scad icinde SADECE poligon var - mesh/import YOK, yani
// bu dosya hala tam parametrik ve serbestce olceklenebilir.
yazi_aktif    = true;
yazi_boyut    = 6.0;    // HARF YUKSEKLIGI [mm].  En/boy orani 8.233,
                        //   yani 6.0 -> 49.4 mm genislik (kapak 61.4 mm,
                        //   her yanda ~6 mm pay). Buyutursen genisligi
                        //   6.0*8.233 formuluyle kontrol et.
yazi_derinlik = 0.8;    // GOMME derinligi [mm] - kubbe yuzeyinden dik olculur
yazi_kaydir_y = 0;      // yatay kaydirma [mm]  (kontur zaten ortalanmis)
yazi_kaydir_z = 0;      // dikey kaydirma [mm]
yazi_aci      = 0;      // yuzey uzerinde donme [deg]
yazi_tasma    = 0.5;    // kesicinin kubbe yuzeyinin DISINA tasmasi [mm]
                        //   (asagidaki tuzak notuna bak - 0 yapma)

$fn = 64;

// --- gecerlilik kontrolleri (profil ters donmesin) ------------------------
assert(bel_kalinlik > taban_kalinlik,
   "bel_kalinlik > taban_kalinlik olmali.");
assert(bel_kalinlik < taban_kalinlik + barb_cikinti,
   "bel_kalinlik, barb tepesinden (taban_kalinlik + barb_cikinti) KUCUK olmali - yoksa barb cikintisi kaybolur, tirnak kavramaz.");
assert(guc_boy < bel_baslangic,
   "guc_boy < bel_baslangic olmali - yoksa gusset esneme boynunu kilitler.");
assert(tab_boy - giris_rampa - barb_tepe - yakalama_boyu > bel_baslangic,
   "tab_boy cok kisa: barb bolgesi bel'in icine giriyor.");

// --- snap-fit kesit profili (X=eksenel, Y=radyal) -------------------------
function snap_poly() = let(
    L  = tab_boy,
    qg = taban_kalinlik + barb_cikinti,      // barb tepe (radyal)
    sr = tab_oturma_capi/2,                  // seat yaricap (barb tepesi burada)
    g  = tab_gomme,
    // (a = tabandan uca eksenel; q = ic yuzden disa radyal). barb tepesi = qg
    P = [
        [-g, 0],                                     // taban ic (gomulu)
        [ L, 0],                                     // uc ic
        [ L, uc_kalinlik],                           // uc dis
        [ L - giris_rampa, qg],                      // BARB tepe - on (lead-in ustu)
        [ L - giris_rampa - barb_tepe, qg],          // BARB duz tepe - arka
        [ L - giris_rampa - barb_tepe - yakalama_boyu, bel_kalinlik], // YAKALAMA (dik dusus)
        [ bel_baslangic, bel_kalinlik],              // BEL (ince boyun)
        [ taban_uzunluk, taban_kalinlik],            // taban dis rampa
        [-g, taban_kalinlik]                         // taban dis (gomulu)
    ]
) [ for (p = P) [ tab_taban_x - p[0], sr - qg + p[1] ] ];  // -> dunya X(eksenel)-Y(radyal)

module snap_tab(theta) {
    translate([0, kapak_cy, kapak_cz])
    rotate([theta, 0, 0])
    linear_extrude(height = tab_teget, center = true)
        if (tab_yuvarlat > 0) offset(r = tab_yuvarlat) offset(delta = -tab_yuvarlat) polygon(snap_poly());
        else polygon(snap_poly());
}

// --- PARAMETRIK KUBBELI DISK (rotate_extrude) ------------
module disk_solid() {
    R   = disk_cap/2;
    sag = disk_tepe_x - disk_kenar_x;                 // kubbe yuksekligi (sagitta)
    Rd  = (R*R + sag*sag) / (2*sag);                  // kubbe (kure) yaricapi
    cx  = disk_tepe_x - Rd;                           // kubbe merkezi (eksende)
    n   = 48;
    arc = [ for (i = [0:n]) let (r = R*(1 - i/n)) [ r, cx + sqrt(max(Rd*Rd - r*r, 0)) ] ];
    prof = concat([[0, disk_arka_x], [R, disk_arka_x], [R, disk_kenar_x]], arc);
    translate([0, kapak_cy, kapak_cz]) rotate([0,90,0])
        rotate_extrude($fn = 160) polygon(prof);
}
module disk_cep() {  // arkadan malzeme azaltma cebi
    x0 = disk_arka_x - 0.1;
    x1 = disk_tepe_x - disk_cidar;
    translate([0, kapak_cy, kapak_cz]) rotate([0,90,0]) translate([0,0,x0])
        linear_extrude(height = x1 - x0) circle(r = disk_cap/2 - disk_cidar, $fn=160);
}
module disk() {
    if (disk_ici_bosalt) difference() { disk_solid(); disk_cep(); }
    else disk_solid();
}

// tirnak dibi guclendirmesi: genis kokten dar tirnaga smooth gecen gusset
module _guc_slab(theta, x, w, ri, ro) {
    translate([0, kapak_cy, kapak_cz]) rotate([theta, 0, 0])
    translate([x, (ri + ro)/2, 0])
    cube([0.8, ro - ri, w], center=true);   // X=eksenel(ince), Y=radyal, Z=tegetsel(w)
}
module tab_guc(theta) {
    sr = tab_oturma_capi/2;
    ri = sr - (taban_kalinlik + barb_cikinti);   // ic yuz
    ro = ri + taban_kalinlik;                     // taban dis yuz
    hull() {
        // genis kok (diske gomulu) - istenen yonlere tasar
        _guc_slab(theta, tab_taban_x + 0.3, tab_teget + 2*guc_teget,
                  ri - guc_radyal_ic, ro + guc_radyal_dis);
        // tirnak boyunca disari, normal kesit (smooth gecis)
        _guc_slab(theta, tab_taban_x - guc_boy, tab_teget, ri, ro);
    }
}

// --- GOMME YAZI ------------------------------------------------------------
// Kubbe kuresel bir kalot; duz bir prizmayla kazisak derinlik merkezden kenara
// degisirdi (45 mm genislikte ~0.9 mm fark - 0.8 mm'lik gomme kenarda hic
// kesmezdi). Bu yuzden kesici = yazi prizmasi ∩ KURESEL KABUK: kabuk, kubbe
// yuzeyinden yazi_derinlik kadar iceri offsetlenmis. Derinlik her yerde esit.
module yazi_2d() {
    rotate(yazi_aci)
    translate([yazi_kaydir_y, yazi_kaydir_z])
    scale(yazi_boyut) subaru_wordmark_2d();
}

module yazi_kesici() {
    R   = disk_cap/2;
    sag = disk_tepe_x - disk_kenar_x;
    Rd  = (R*R + sag*sag) / (2*sag);      // kubbe kuresinin yaricapi
    cx  = disk_tepe_x - Rd;               // kure merkezi (eksen = X)
    intersection() {
        translate([0, kapak_cy, kapak_cz])
        // +X'ten (on yuzden) bakildiginda ekran sagi = +Y'dir. Yazinin
        // ilerleme yonu +Y olmali; rotate([90,0,-90]) local x'i -Y'ye
        // esler ve yazi AYNALI cikar. Dogrusu +90.
        rotate([90, 0, 90])
        translate([0, 0, -60])
        linear_extrude(height = 120)
        yazi_2d();

        // TUZAK: kesicinin dis kuresi ile kubbe yuzeyi FARKLI poligon
        // yaklasimlari (sphere $fn vs rotate_extrude arc n). Ikisi tam ust
        // uste gelmedigi icin dis kureyi tam Rd'de birakirsan harflerin
        // uzerinde yer yer 0.0x mm'lik ZAR kalir; oyuk yuzeye acilmaz,
        // KAPALI BOSLUK olur (CGAL "Volumes" 2 yerine 8 cikar) ve baski
        // tepesi kapali gelir. Dis kureyi yuzeyin disina tasirmak sart;
        // gomme derinligi yine gercek yuzeyden olculur cunku ic kure Rd'ye
        // gore konumlanmis.
        translate([cx, kapak_cy, kapak_cz])
        difference() {
            sphere(r = Rd + yazi_tasma,    $fn = 220);
            sphere(r = Rd - yazi_derinlik, $fn = 220);
        }
    }
}

difference() {
union() {
    disk();                                   // parametrik disk
    for (i = [0 : tab_sayisi - 1]) {
        aci = tab_aci0 + i * 360/tab_sayisi;
        snap_tab(aci);
        if (taban_guc_aktif) tab_guc(aci);
    }
}
    if (yazi_aktif) yazi_kesici();
}
