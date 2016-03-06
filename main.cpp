#include <iostream>

#include <SFML/Graphics.hpp>

using namespace std;

extern "C" int ASM(sf::Uint8* tab, double x, double y, double zoom);

sf::Uint8 table[512][514*4];

sf::Sprite sprite;
sf::Texture texture;

int main()
{
	double x=-2.0;
	double y=-1.5;
	double zoomd=3;
	double przes;
	double temp;

	sf::RenderWindow window(sf::VideoMode(512, 512), "ARKO x64 fraktal");

	texture.create(512, 512);
	texture.setSmooth(false);

	sf::Event event;

	ASM(*table, x, y, zoomd);

	while (window.isOpen())
	{
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed) window.close();

			if (event.type == sf::Event::KeyReleased)
			{

				if( event.key.code == sf::Keyboard::Right ) 
				{
					x+=przes;
				}
				if( event.key.code == sf::Keyboard::Left ) 
				{
					x-=przes;
				}
				if( event.key.code == sf::Keyboard::Up ) 
				{
					y-=przes;
				}
				if( event.key.code == sf::Keyboard::Down ) 
				{
					y+=przes;
				}
				if( event.key.code == sf::Keyboard::Numpad1 ) 
				{
					temp = zoomd;
					zoomd=zoomd*1.25;
					temp=(zoomd-temp)/2;
					x-=temp;
					y-=temp;

				}
				if( event.key.code == sf::Keyboard::Numpad2 ) 
				{
					temp = zoomd;
					zoomd=zoomd*0.75;
					temp=(temp-zoomd)/2;
					x+=temp;
					y+=temp;
				}
				przes = zoomd/10;
				ASM(*table, x, y, zoomd);
				cout<<x<<" "<<y<<" "<<zoomd<<"\n";
			}
		}

		texture.update(*table);
		sprite.setTexture(texture);

		window.clear();
		window.draw(sprite);
		window.display();
	}
}