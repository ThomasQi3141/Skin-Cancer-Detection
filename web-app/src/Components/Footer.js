import styled from "styled-components";

const Footer = styled.footer`
  color: ${(props) => props.textColor};
  text-align: center;
  padding: 1rem;
  position: relative;
  width: 100%;
  bottom: 0;
  margin-top: 5rem;
`;

export default Footer;
