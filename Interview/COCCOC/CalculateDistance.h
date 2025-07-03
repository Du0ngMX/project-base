#ifndef CALCULATE_DISTANCE_H_
#define CALCULATE_DISTANCE_H_

#include <fstream>
#include <string>
#include <map>
#include <cmath>

typedef std::map<std::string, int> document;

namespace task {

    class CalculateDistance {
      public:
        /*!
         * @brief The Constructor.
         * @param [in]
         * @return None.
         */
        explicit CalculateDistance(const std::string &path_first, const std::string path_second);

        /*!
         * @brief Copy constructor is not supported.
         * @param None.
         * @return None.
         */
        CalculateDistance(const CalculateDistance &) = delete;

        /*!
         * @brief Copy assignment is not supported.
         * @param None.
         * @return None.
         */
        CalculateDistance &operator=(const CalculateDistance &) = delete;

        /*!
         * @brief The destructor, using default
         * @param None.
         * @return None.
         */
        ~CalculateDistance(void) = default;

        /*!
         *  @brief The angle between these two vectors.
         *
         *  @param [in] document d1
         *  @param [in] document d2
         *
         *  @return distance.
         */
        double VectorAngle(document d1, document d2);
    private:

        //! The path file
        std::string path_first_doc;
        std::string path_second_doc;

        //! The document
        document d1;
        document d2;

        /*!
         * @brief count frequency of each word.
         *
         * @param [in] ifstream file.
         *
         * @return a dictionary mapping words to frequency.
         */
        document CountWords(std::ifstream &fin);

        int InnerProduct(document d1, document d2);
    };
}

#endif /* CALCULATE_DISTANCE_H_ */
