﻿using System;
using System.Diagnostics;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;
using System.Windows.Threading;

namespace KinectSpaceToWindowCoords
{
    public class MainWindowViewModel : PropertyChangeBase
    {
        [DllImportAttribute("user32.dll", EntryPoint = "SetCursorPos")]
        [return: MarshalAsAttribute(System.Runtime.InteropServices.UnmanagedType.Bool)]
        public static extern bool SetCursorPos(int X, int Y);

        [DllImport("user32.dll")]
        private static extern void mouse_event(UInt32 dwFlags, UInt32 dx, UInt32 dy, UInt32 dwData, IntPtr dwExtraInfo);
        private const UInt32 MouseEventLeftDown = 0x0002;
        private const UInt32 MouseEventLeftUp = 0x0004;

        private int currentPage = 0;
        private int dummyVariable = 0;

        double cursorX;
        double cursorY;
        string uri;
        double scale;
        DispatcherTimer cameraTimer;
        Rectangle workingArea;

        private System.Windows.Input.Cursor gripCursor;

        System.Windows.Forms.Timer cursorTimer;

        public MainWindowViewModel()
        {
            this.Initialize();
            gripCursor = new System.Windows.Input.Cursor(Application.StartupPath + "\\fist.cur");
        }

        #region Properties

        /// <summary>
        /// Acts as a logger for application
        /// </summary>
        public BindableTraceListener TraceListener
        {
            get { return App.TraceListener; }
        }

        /// <summary>
        /// Sets and gets the scale factor for real world coordinates to cursor coordinates
        /// </summary>
        public double Scale
        {
            get { return this.scale; }
            set
            {
                this.scale = value;
                this.OnPropertyChanged("Scale");
            }
        }

        /// <summary>
        /// Gets or sets the browser URI
        /// </summary>
        public string URI
        {
            get { return this.uri; }
            set
            {
                if (this.uri != value)
                {
                    this.uri = value;
                    this.OnPropertyChanged("URI");
                }
            }
        }

        /// <summary>
        /// Sets mouse cursor x position
        /// </summary>
        public double CursorX
        {
            get { return this.cursorX; }
            set
            {
                this.cursorX = value;
                this.OnPropertyChanged("CursorX");
            }
        }

        /// <summary>
        /// Sets mouse cursor y position
        /// </summary>
        public double CursorY
        {
            get { return this.cursorY; }
            set
            {
                this.cursorY = value;
                this.OnPropertyChanged("CursorY");
            }
        }

        /// <summary>
        /// Gets hand coordinate x
        /// </summary>
        public double SensorX
        {
            get { return CameraSession.PositionX; }
        }

        /// <summary>
        /// Gets hand coordinate y
        /// </summary>
        public double SensorY
        {
            get { return CameraSession.PositionY; }
        }

        #endregion

        #region Public Interface Methods
        /// <summary>
        /// Increments cursor movement scale factor
        /// </summary>
        public void IncrementScale()
        {
            if (this.Scale < 10)
                this.Scale++;
        }

        /// <summary>
        /// Decrements cursor movement scale factor
        /// </summary>
        public void DecrementScale()
        {
            if (this.Scale > 1)
                this.Scale--;
        }
        #endregion

        /// <summary>
        /// Sends a mouse click to interface
        /// </summary>
        public static void SendMouseClick()
        {
            mouse_event(MouseEventLeftDown, 0, 0, 0, new System.IntPtr());
            mouse_event(MouseEventLeftUp, 0, 0, 0, new System.IntPtr());
        }

        /// <summary>
        /// Initialization routine for main functionality
        /// </summary>
        void Initialize()
        {
            Trace.Listeners.Add(App.TraceListener);

            this.Scale = 2d;
            this.Scale++;
            var start = new ThreadStart(CameraSession.Run);
            var cameraThread = new Thread(start);
            cameraThread.Start();
            
            Trace.Flush();
            Trace.Write("Initializing...");

            // assumes only single/first monitor
            var screen = Screen.AllScreens[0];
            this.workingArea = screen.WorkingArea;

            this.cameraTimer = new DispatcherTimer(){ Interval = TimeSpan.FromMilliseconds(10) };
            this.cameraTimer.Tick += new EventHandler(cameraTimer_Tick);
            this.cameraTimer.Start();

            this.cursorTimer = new System.Windows.Forms.Timer() { Interval = 1 };
            this.cursorTimer.Tick += new EventHandler(cursorTimer_Tick);

            Trace.Write("Kinect device starting...");
        }

        /// <summary>
        /// Rapidly changes the mouse cursor
        /// </summary>
        void cursorTimer_Tick(object sender, EventArgs e)
        {
            System.Windows.Input.Mouse.OverrideCursor = gripCursor;
        }

        /// <summary>
        /// Updates working state with Kinect state data
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void cameraTimer_Tick(object sender, EventArgs e)
        {
            if (CameraSession.KinectFail)
            {
                Trace.WriteLine("No Kinect device was found. Sorry.");
                this.cameraTimer.Stop();
                return;
            }
            
            if (CameraSession.KinectExists)
            {
                if (CameraSession.Active)
                {
                    this.CursorX = this.workingArea.Width / 2 + CameraSession.PositionX * this.Scale;
                    this.CursorY = this.workingArea.Height / 2 - CameraSession.PositionY * this.Scale;
                    this.OnPropertyChanged("SensorX");
                    this.OnPropertyChanged("SensorY");
                    SetCursorPos((int)this.cursorX, (int)this.cursorY);

                    if (CameraSession.HorSwipeStarted || CameraSession.VertSwipeStarted)
                    {
                        cursorTimer.Start();
                        Trace.WriteLine("swipe started");
                    }
                    else if (!CameraSession.HorSwipeStarted && !CameraSession.VertSwipeStarted)
                        cursorTimer.Stop();

                    if (CameraSession.SwipeLeft)
                        SwipedLeft();
                    if (CameraSession.SwipeRight)
                        SwipedRight();
                    if (CameraSession.SwipeUp)
                        SwipedUp();
                    if (CameraSession.SwipeDown)
                        SwipedDown();
                    if (CameraSession.Push)
                        Pushed();
                }
                else
                {
                    //TODO: Some sort of notification/overlay
                }
            }
            else
            {
                //TODO: Some sort of notification/overlay
            }
        }

        #region Gesture Handlers

        /// <summary>
        /// Handles Left Swipe
        /// </summary>
        public void SwipedLeft()
        {
            if (currentPage < 10)
            {
                currentPage++;
                this.URI = "$('a.col" + currentPage + "').click()";
                this.URI = "$('a.col" + currentPage + "').click()";

            }
            CameraSession.SwipeRight = CameraSession.SwipeLeft = false;
        }

        /// <summary>
        /// Handles Right Swipe
        /// </summary>
        public void SwipedRight()
        {
            if (currentPage > 0)
            {
                currentPage--;
                if (currentPage == 0)
                    this.URI = "$('a.all').click()";
                else
                {
                    this.URI = "$('a.col" + currentPage + "').click()";
                    this.URI = "$('a.col" + currentPage + "').click()";
                }
            }
            CameraSession.SwipeLeft = CameraSession.SwipeRight = false;
        }

        /// <summary>
        /// Handles Up Swipe
        /// </summary>
        public void SwipedUp()
        {
            this.URI = "$('html, body').animate({'scrollTop': $('body').scrollTop() + 0.5*$(window).height()}); if(null){" + dummyVariable + "}";
            CameraSession.SwipeDown = CameraSession.SwipeUp = false;
            dummyVariable = (dummyVariable + 1) % 2;
        }

        /// <summary>
        /// Handles Down Swipe
        /// </summary>
        public void SwipedDown()
        {
            this.URI = "$('html, body').animate({'scrollTop': $('body').scrollTop() - 0.5*$(window).height()}); if(null){" + dummyVariable + "}";
            CameraSession.SwipeUp = CameraSession.SwipeDown = false;
            dummyVariable = (dummyVariable + 1) % 2;
        }

        /// <summary>
        /// Handles Push
        /// </summary>
        public void Pushed()
        {
            SendMouseClick();
            CameraSession.Push = false;
        }

        #endregion
    }
}