using System;

namespace _9_ClassesChallenge
{
    public class Program
    {
        public static void Main(string[] args)
        {
            Human human1 = new Human();
            Human human2 = new Human("Yang", "Wenli");

            Console.WriteLine(human1.AboutMe());
            Console.WriteLine(human2.AboutMe());

            Human2 human3 = new Human2("Jane", "Doe", "Brown");
            Human2 human4 = new Human2("Alice", "Smith", 30);
            Human2 human5 = new Human2("Bob", "Johnson", "Green", 25);

            Console.WriteLine(human3.AboutMe2());
            Console.WriteLine(human4.AboutMe2());
            Console.WriteLine(human5.AboutMe2());

            Human2 human6 = new Human2();
            human6.Weight = 100;
            Console.WriteLine($"Weight is {human6.Weight}.");
            human6.Weight = -5;
            Console.WriteLine($"Weight is {human6.Weight}.");
        }
    }
}
