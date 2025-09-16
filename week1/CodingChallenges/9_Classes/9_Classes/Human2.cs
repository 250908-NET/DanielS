using System;
using System.Runtime.CompilerServices;
using System.Text;

[assembly: InternalsVisibleTo("9_ClassesChallenge.Tests")]
namespace _9_ClassesChallenge
{
    internal class Human2
    {
        private string lastName = "Smyth";
        private string firstName = "Pat";
        private string eyeColor;
        private int age;
        private int _weight;

        public Human2(string firstName, string lastName)
        {
            this.firstName = firstName;
            this.lastName = lastName;
        }

        public Human2()
        {
            this.firstName = "Pat";
            this.lastName = "Smyth";
        }

        public Human2(string firstName, string lastName, string eyeColor, int age)
        {
            this.firstName = firstName;
            this.lastName = lastName;
            this.eyeColor = eyeColor;
            this.age = age;
        }

        public Human2(string firstName, string lastName, int age)
        {
            this.firstName = firstName;
            this.lastName = lastName;
            this.age = age;
        }

        public Human2(string firstName, string lastName, string eyeColor)
        {
            this.firstName = firstName;
            this.lastName = lastName;
            this.eyeColor = eyeColor;
        }

        public string AboutMe()
        {
            return $"My name is {firstName} {lastName}.";
        }

        public string AboutMe2()
        {
            StringBuilder result = new StringBuilder();

            result.Append($"My name is {firstName} {lastName}.");

            bool hasAge = age > 0;
            bool hasEyeColor = !string.IsNullOrEmpty(eyeColor);

            if (hasAge) result.Append($" My age is {age}.");
            if (hasEyeColor) result.Append($" My eye color is {eyeColor}.");

            return result.ToString();
        }

        public int Weight
        {
            get
            {
                return _weight;
            }
            set
            {
                if (value < 0 || value > 400)
                    _weight = 0;
                else
                    _weight = value;
            }
        }
    }
}
