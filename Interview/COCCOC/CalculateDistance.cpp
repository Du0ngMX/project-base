#include "CalculateDistance.h"

namespace task {

    /*!
     * @brief The constructor.
     * @param [in] sharedMemory the shared memory from main.
     * @return None.
     */
    CalculateDistance::CalculateDistance(const std::string &path_first, const std::string &path_second)
        : path_first_doc { path_first }, path_second_doc { path_second }, d1 {}, d2 {}
    {
    }

    /*!
     *  @brief The main method for building difference map.
     *
     *  @param [in] request the HTTP request data
     *  @param [out] response the HTTP response data
     *
     *  @return None.
     */
    document CalculateDistance::CountWords(std::ifstream &fin) {
      document result;
      std::string str;

      while (fin >> str) {
        ++result[str];
      }
      return result;
    }

    int CalculateDistance::InnerProduct() {
      int sum = 0;
      for (auto w : d1) {
        if (d2.find(w.first) != d2.end()) {
          sum += w.second * d2[w.first];
        }
      }
      return sum;
    }

    double CalculateDistance::VectorAngle() {
      int numerator = InnerProduct(d1, d2);
      double denominator = sqrt(InnerProduct(d1, d1) * InnerProduct(d2, d2));
      return acos(numerator / denominator);
    }
}