import streamlit as st
import openai
from transformers import AutoTokenizer, AutoModelForQuestionAnswering
import torch

# Initialize the OpenAI API client
openai.api_key = "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"

# Initialize the question answering model
tokenizer = AutoTokenizer.from_pretrained("distilbert-base-uncased-distilled-squad")
model = AutoModelForQuestionAnswering.from_pretrained("distilbert-base-uncased-distilled-squad")

def main():
    # Set the page title and header
    st.title("AI Education Tool")
    st.header("Enter a topic and I'll generate a context, question, and assess your answer.")

    # Get the topic from the user
    topic = st.text_input("Topic:")

    # Generate the context, question, and answer
    context = generate_context(topic)
    question = generate_question(context)
    answer = generate_answer(context, question)

    # Display the context, question, and answer to the user
    st.write("**Context:**")
    st.write(context)
    st.write("**Question:**")
    st.write(question)
    st.write("**Answer:**")
    st.write(answer)

    # Get the user's answer
    user_answer = st.text_input("Your Answer:")

    # Assess the user's answer
    assessment = assess_answer(user_answer, answer)

    # Display the assessment to the user
    st.write("**Assessment:**")
    st.write(assessment)

def generate_context(topic):
    prompt = f"Generate a short context about {topic}."
    response = openai.chat.completions.create(model="gpt-3.5-turbo-16k",
    messages=[
        {
            "role":"user",
            "content": prompt,
        }
    ])
    return response.choices[0].message.content

def generate_question(context):
    prompt = f"Generate a multiple-choice question based on the following context:\n\n{context}"
    response = openai.chat.completions.create(model="gpt-3.5-turbo-16k",
    messages=[
        {
            "role":"user",
            "content": prompt,
        }
    ])
    return response.choices[0].message.content

def generate_answer(context, question):
  prompt = f"Answer the following question based on the provided context:\n\nContext:\n{context}\n\nQuestion:\n{question}"
  response = openai.chat.completions.create(model="gpt-3.5-turbo-16k",
  messages=[
      {
          "role": "user",
          "content": prompt,
      }
  ])
  return response.choices[0].message.content

def assess_answer(user_answer, answer):
  if user_answer == answer:
        return "Correct!"
  else:
        return "Incorrect. The correct answer is: " + answer

if __name__ == "__main__":
    main()
