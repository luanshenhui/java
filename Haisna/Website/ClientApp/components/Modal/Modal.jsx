/* eslint react/prop-types: 0 */
import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import DialogTitle from '@material-ui/core/DialogTitle';

const Modal = (props) => (
  <Dialog maxWidth={false} {...props}>
    {props.caption && <DialogTitle>{props.caption}</DialogTitle>}
    {props.children}
  </Dialog>
);

export default Modal;
