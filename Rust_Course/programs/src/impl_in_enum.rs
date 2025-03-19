//Agar hume enum ke saath methods likhne ho to impl block ka use kar sakte hain
enum TrafficLight {
    Red,
    Yellow,
    Green,
}

impl TrafficLight {
    fn action(&self) {
        match self {
            TrafficLight::Red => println!("Stop!"),
            TrafficLight::Yellow => println!("Get Ready!"),
            TrafficLight::Green => println!("Go!"),
        }
    }
}

pub fn run() {
    let signal = TrafficLight::Green;
    signal.action();
}
